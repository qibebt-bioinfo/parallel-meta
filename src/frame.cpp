// Updated at Sept 19, 2018
// Updated by Xiaoquan Su
// Bioinformatics Group, Single-Cell Research Center, QIBEBT, CAS

#include <iostream>

#include "init.h"
#include "fastq.h"
#include "ExtractRNA.h"
#include "multialign.h"
#include "taxonomy.h"

using namespace std;

void Single_Run(_Para para){
     
    string command;
    
    int seq_count = 0;
    int rna_count = 0;
    int match_rna_count = 0;
    int drop_rna_count = 0; 
    
    int a_diver [LEVEL] = {0, 0, 0, 0, 0, 0, 0};
    
    para.Format = Check_Format(para.Infilename.c_str()); 
    
    if (para.Format < 0) return; //Format error
    
    if (para.Is_format_check){//Check format
                         cout << "Format Check Starts" << endl;
                         command = para.This_path + "/bin/PM-format-seq -i " + para.Infilename;
                         system(command.c_str());
                         cout << endl;
                         }
                               
    if (para.Format == 1){//If fastq
                    
        string tempfilename = para.Out_path + "/meta.fasta";
        cout << "Pre-computation for Fastq Starts" << endl;
        cout << endl << Fastq_2_Fasta(para.Infilename.c_str(), tempfilename.c_str()) << " sequences have been pre-computed" << endl << endl;
        para.Infilename = tempfilename;
        
        }
    
    //for pair ends
    if (para.Is_paired){
                        para.Format = Check_Format(para.Infilename2.c_str()); 
                        if (para.Format < 0) return;
                        if (para.Is_format_check){//Check format
                                                 cout << "Format Check 2 Starts" << endl;
                                                 command = para.This_path + "/bin/PM-format-seq -i " + para.Infilename2;
                                                 system(command.c_str());
                                                 cout << endl;
                                                 }
                        if (para.Format == 1){//If fastq     
                                             string tempfilename = para.Out_path + "/meta2.fasta";
                                             cout << endl << Fastq_2_Fasta(para.Infilename2.c_str(), tempfilename.c_str()) << " sequences have been pre-computed" << endl << endl;
                                             para.Infilename2 = tempfilename;                                                        
                            }
                        }
            
    if (para.Type == 1){ //If meta
         //Extract 16S r RNA
         seq_count = ExtractRNA(para.Database.Get_Domain(), para.Infilename, para.Out_path, para.Length_filter, para.This_path, para.Core_number);
    
         //Parallel-megablast to map
         rna_count = Parallel_Align(para.Align_exe_name.c_str(), para.Out_path + "/meta.rna", para.Out_path + "/tmp", para.Database.Get_Path() + "/database", para.Align_mode, para.Core_number, "");
         }
    else if (para.Is_paired){ // If paired
        //Parallel-megablast to map
         rna_count = Parallel_Align_Paired(para.Align_exe_name.c_str(), para.Infilename, para.Infilename2, para.Out_path + "/tmp", para.Database.Get_Path()+ "/database", para.Align_mode, para.Paired_mode, para.Core_number, "");
         
         if (rna_count < 0) {                       
                       cerr << "Error: 2 ends contain different number of sequences" << endl;
                       return;
                       }
         }
    else 
         rna_count = Parallel_Align(para.Align_exe_name.c_str(), para.Infilename, para.Out_path + "/tmp", para.Database.Get_Path() + "/database", para.Align_mode, para.Core_number, "");
    
    //parse_taxonomy 
    Out_Taxonomy((para.Out_path + "/tmp/map_output.txt").c_str(), para.Out_path, para.Database, 0, a_diver, para.Is_paired, match_rna_count, drop_rna_count);
          
    //make_plot
    command = para.This_path + "/bin/PM-plot-taxa -D " + para.Database.Get_Id() + " -i " + para.Out_path + "/classification.txt -o " + para.Out_path;
    system(command.c_str());
    
    //print report
    Print_Report(para, seq_count, rna_count, match_rna_count, a_diver);
    
    //func_anno
    if (para.Is_func){
       //func
       command = para.This_path + "/bin/PM-predict-func -D " + para.Database.Get_Id() + " -i " + para.Out_path + "/classification.txt -o " + para.Out_path;
       system(command.c_str());       
       //nsti
       command = para.This_path + "/bin/PM-predict-func-nsti -D " + para.Database.Get_Id() + " -i " + para.Out_path + "/classification.txt >> " + para.Out_path + "/Analysis_Report.txt";
       system(command.c_str());   
       }
    //Remove the tmp 
    command = "rm -rf " + para.Out_path + "/tmp";
    system(command.c_str());
         
    }
int main(int argc, char * argv[]){
    
    cout << endl << "Welcome to Parallel-META version " << Version << endl << endl; 
    
    _Para para;         
    
    Parse_Para(argc, argv, para);
    
    Single_Run(para);
    
    cout << endl << "Parallel-META Finished" << endl;
    cout << "Please check the analysis results and report at " << para.Out_path <<endl;
     
    return 0;
    }
