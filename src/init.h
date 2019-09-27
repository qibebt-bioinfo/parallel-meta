// Updated at Dec 26, 2018
// Bioinformatics Group, Single-Cell Research Center, QIBEBT, CAS

#include <iostream>
#include <fstream>
#include <stdlib.h>

#include <sys/dir.h>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h>
#include "utility.h"
#include "version.h"
#include "db.h"

using namespace std;

#ifndef INIT_H
#define INIT_H

#define LEVEL 7

//Parameters
class _Para{
      public:
             _Para(){
                     This_path = Check_Env();
                     Align_exe_name = This_path + "/Aligner/bin/bowtie2-align-s";
                     Length_filter = 0;
                     Core_number = 0;
                     Type = -1;
                     Out_path = "./Result";
                     Align_mode = "very-sensitive-local";
                 
             
                     Is_format_check = false;  
                     Is_paired = false; 
                     Is_func = true;
                     Paired_mode = "fr";
                     }
             
             string This_path;
             string Align_exe_name;
             string Infilename;
             string Infilename2;
             string Groupfilename;
             string Listfilename;
             string Out_path;
             string Align_mode;
    
             int Type; //0: 16S 1: shotgun
             int Format; //0: fasta 1: fastq;
             int Length_filter;
             int Core_number;
             bool Is_format_check;
             bool Is_paired;
             string Paired_mode;
             bool Is_func;
    
             _PMDB Database;
             };

int Print_Help(){
    
    cout << "Parallel-META version: " << Version << endl;
    cout << "\tMicrobiome sample profiling" << endl;
    cout << "Usage:" << endl;
    cout << "PM-parallel-meta [Option] Value" << endl;
    cout << "Options: " << endl;
    cout << "\t-D (upper) ref database, " << _PMDB::Get_Args() << endl;
    
    cout << "\t[Input options, required]" << endl;
    cout << "\t  -m Input single sequence file (Shotgun) [Conflicts with -r and -R]" << endl;
    cout << "\t  or" << endl;
	cout << "\t  -r Input single sequence file (rRNA targeted) [Conflicts with -m]" << endl;
	cout << "\t  -R (upper) Input paired sequence file [Optional for -r, Conflicts with -m]" << endl;
    cout << "\t  -P (upper) Pair-end sequence orientation for -R" << endl;
    cout << "\t     0: Fwd & Rev, 1: Fwd & Fwd, 2: Rev & Fwd, default is 0" << endl;
    
    cout << "\t[Output options]" << endl;
	cout << "\t  -o Output path, default is \"Result\"" << endl;
    
    cout << "\t[Other options]" << endl;
	cout << "\t  -e Alignment mode" << endl;
	cout << "\t     0: very fast, 1: fast, 2: sensitive, 3: very-sensitive, default is 3" << endl;
    cout << "\t  -k Sequence format check, T(rue) or F(alse), default is F" << endl;
	cout << "\t  -L (upper) rRNA length threshold of rRNA extraction. 0 is disabled, default is 0 [Optional for -m, Conflicts with -r]" << endl;
    cout << "\t  -f Functional analysis, T(rue) or F(alse), default is T" << endl;
    cout << "\t  -t Cpu core number, default is auto" << endl;
    cout << "\t  -h Help" << endl;
    
    exit(0);
    
    }

int Print_Config(_Para para){
    
    cout << "The reference sequence database is ";
    cout << para.Database.Get_Description() << endl;
    
    cout << "The input sequence Type is ";
    if (para.Type == 1) cout << "Metagenomic Shotgun Sequences" << endl;
    else cout << "rRNA Targeted Sequences" << endl;
    
    cout << "The input sequence is " << para.Infilename << endl;
    if (para.Is_paired)
       cout << "The input pair sequence is " << para.Infilename2 << endl;
        
    cout << "The functional annotation is ";
    if (para.Is_func ) cout << "On" << endl;
    else cout << "Off" << endl;
       
    cout << "The core number is " << para.Core_number << endl << endl;

    return 0;
    
    }

int Print_Report(_Para para, unsigned int seq_count, unsigned int rna_count, unsigned int match_rna_count, int * a_diver){
    
    ofstream outfile((para.Out_path + "/Analysis_Report.txt").c_str(), ofstream::out);
    
    if (!outfile){
                  cerr << "Error: Open Analysis Report file error : " << para.Out_path + "/Analysis_Report.txt" << endl;
                  return 0;
                  }
    
    string taxa_name [LEVEL] = {"Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "OTU"};
    
    outfile << "Parallel-META Analysis Report" << endl;
    outfile << "Version " << Version << endl;
    
    outfile << "Domain : ";
    
    outfile << para.Database.Get_Description() << endl;
    
    outfile << "Input Type : ";
    if (para.Type == 1) outfile << "Metagenomic Shotgun Sequences" << endl;
    else outfile << "rRNA Targeted Sequences" << endl; 
    
    outfile << "Input File : " << para.Infilename << endl;
    
    if (para.Is_paired){
       outfile << "Input Paired File : " << para.Infilename2 << endl;
       outfile << "Input Paired File rientation : " << para.Paired_mode << endl;
       }
       
    if (para.Type == 1){
       outfile << "rRNA Extraction Length Filter : ";
       if (para.Length_filter == 0) outfile << "Off" << endl;
       else outfile << para.Length_filter << endl;
       }

    outfile << "Alignment Mode : " << para.Align_mode << endl;
            
    if (para.Type == 1)
    outfile << "Metagenomic Sequence Number : " << seq_count << endl;
    
    outfile << "rRNA Sequence Number : " << rna_count << endl;
    
    outfile << "Mapped rRNA Sequence Number : " << match_rna_count << endl;
    
    outfile << "Alpha Diversity:" << endl;
    
    for (int i = 0; i < LEVEL; i ++)
        outfile << taxa_name[i] << "\t" << a_diver[i] << endl;
    
    outfile.close();
    outfile.clear();
    
    return 0;
    }

int Parse_Para(int argc, char * argv[], _Para &para){ //Parse Parameters

    if (argc ==1) 
		Print_Help();
    
    int i = 1;
    
    while(i<argc){
         if (argv[i][0] != '-') {
                           printf("Argument # %d Error : Arguments must start with -\n", i);
                           exit(0);
                           };           
         switch(argv[i][1]){
                            case 'D' : para.Database.Set_DB(argv[i+1][0]);
                                       break; //Default is 16S
                 
                            case 'm' : if (para.Type != -1){
                                                     cerr << "Error: -m conflicts with -r" << endl;
                                                     exit(0);
                                                     }
                                       para.Infilename = argv[i+1];
                                       para.Type = 1;                                                                                                          
                                       break;  
                            
                            case 'r' : if (para.Type != -1){
                                                     cerr << "Error: -r conflicts with -m" << endl;
                                                     exit(0);
                                                     }
                                       para.Infilename = argv[i+1];  
                                       para.Type = 0;
                                       break;  
                            
                            case 'R' : para.Infilename2 = argv[i+1];                                        
                                       para.Is_paired = true;
                                       break;
                            
                            case 'P': switch (argv[i+1][0]){
                                                             case '0': para.Paired_mode = "fr"; break;
                                                             case '1': para.Paired_mode = "ff"; break;
                                                             case '2': para.Paired_mode = "rf"; break;
                                                             default: para.Paired_mode = "fr"; break;
                                                             }
                                       break; // Default is "fr"
                            case 'o' : para.Out_path = argv[i+1]; break; //Default is ./result                      
     
                            case 'e' : switch (argv[i+1][0]){
                                                             case '0': para.Align_mode = "very-fast-local"; break;
                                                             case '1': para.Align_mode = "fast-local"; break;
                                                             case '2': para.Align_mode = "sensitive-local"; break;
                                                             case '3': para.Align_mode = "very-sensitive-local"; break;
                                                             default: para.Align_mode = "very-sensitive-local"; break;                   
                                              }
                                        break; //Default is "very-sensitive-local"
                            case 'k' : if ((argv[i+1][0] == 't') || (argv[i+1][0] == 'T' )) para.Is_format_check = true; 
                                       else if ((argv[i+1][0] == 'f') || (argv[i+1][0] == 'F' )) para.Is_format_check = false;
                                       break;
                                        
                            case 'L' : para.Length_filter = atoi(argv[i+1]);
                                       if (para.Length_filter < 0){
                                                   cerr << "Error: Length Filter must be equal or larger than 0" << endl;
                                                   exit(0);      
                                                         }
                                       break; //Default is 0
                            case 't' : para.Core_number = atoi(argv[i+1]); break; //Default is Auto                                       
                            case 'f' : if ((argv[i+1][0] == 'F') || (argv[i+1][0]) == 'f' ) para.Is_func = false; break; //Default is On
                            case 'h' : Print_Help(); break;

                            default : printf("Error: Unrec argument %s\n", argv[i]); Print_Help(); break; 
                            }
         i+=2;
         }
    
    //check func
    if (!para.Database.Get_Is_Func()) para.Is_func = false;
    
    //check input
    if (para.Infilename.size() == 0){
                                      cerr << "Error: Please input the sequence file by -m or -r ( and -R)" << endl;             
                                      exit(0);
                                      }
    
    //check pair
    if (para.Is_paired){
                        if (para.Type != 0){
                                      cerr << "Error: Pair-end sequences only support 16S rRNA" << endl;
                                      exit(0);
                                      }                        
                        }
                
    Check_Path(para.Out_path.c_str(), 0); //Check output path 
    Check_Path((para.Out_path + "/tmp").c_str(), 0);    
    
    int max_Core_number = sysconf(_SC_NPROCESSORS_CONF);
    
    if ((para.Core_number <= 0) || (para.Core_number > max_Core_number)){
                    //cerr << "Core number must be larger than 0, change to automatic mode" << endl;
                    para.Core_number = max_Core_number;
                    }
                         
    Print_Config(para);
    
    return para.Type;    
    }

#endif
