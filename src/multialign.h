// Updated at May 18, 2016
// Bioinformatics Group, Single-Cell Research Center, QIBEBT, CAS
//version 3.1 or above with Bowtie2

#include <iostream>
#include <fstream>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <dirent.h>

#include <sys/types.h>
#include <sys/dir.h>
#include <sys/wait.h>
#include <sys/stat.h>

#include "utility.h"

#ifndef MULTIALIGN_H
#define MULTIALIGN_H

#define Seq_Size 500

using namespace std;

int Parallel_Align(string programname, string infilename, string outpath, string database_path, string mode, int coren, string other_args){
    
    //New aligner: bowtie2-align-s
    cout << "Mapping starts" << endl;
        
    int seq_n = Get_Count(infilename.c_str());

    cout << "There are " << seq_n << " sequences in total" << endl << endl;
    
    mkdir((outpath + "/maptemp").c_str(), 0755);
    
    //command
    
    char command[BUFFER_SIZE];
    
    sprintf(command, "%s -x %s --%s --no-hd --no-sq --quiet -p %d -f %s -S %s/map_output.txt %s", programname.c_str(), database_path.c_str(), mode.c_str(), coren, infilename.c_str(), outpath.c_str(), other_args.c_str());
    system(command);
    
    cout << "Mapping Finished" << endl ;   
    return seq_n;
    }

int Parallel_Align_Paired(string programname, string infilename_1, string infilename_2, string outpath, string database_path, string mode, string paired_mode, int coren, string other_args){
    
    //New aligner: bowtie2-align-s
    cout << "Mapping starts" << endl;
        
    int seq_n_1 = Get_Count(infilename_1.c_str());  
    int seq_n_2 = Get_Count(infilename_2.c_str());  
    
    if (seq_n_1 != seq_n_2) return -1;
    
    cout << "There are " << seq_n_1 << " paired sequences in total" << endl << endl;
    
    mkdir((outpath + "/maptemp").c_str(), 0755);
    
    //command
    
    char command[BUFFER_SIZE];
    
    sprintf(command, "%s -x %s --%s --no-hd --no-sq --quiet -p %d -f -1 %s -2 %s -S %s/map_output.txt --%s %s", programname.c_str(), database_path.c_str(), mode.c_str(), coren, infilename_1.c_str(), infilename_2.c_str(), outpath.c_str(), paired_mode.c_str(), other_args.c_str());
    system(command);
    
    cout << "Mapping Finished" << endl ;   
    return seq_n_1;
    }

#endif
