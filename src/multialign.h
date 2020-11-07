// Updated at May 18, 2016
// Bioinformatics Group, Single-Cell Research Center, QIBEBT, CAS
//version 3.1 or above with Bowtie2
// Last update time: Nov 6, 2020
// Updated by Yuzhu Chen
// Notes: change bowtie->vsearch

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

int Parallel_Align(string programname, string infilename, string outpath, string database_path, char Is_denoised, char Is_nonchimeras, string other_args){

    cout << "Mapping starts" << endl;
        
    int seq_n = Get_Count(infilename.c_str());

    cout << "There are " << seq_n << " sequences in total" << endl << endl;
    
    mkdir((outpath + "/maptemp").c_str(), 0755);    
    
    //command  
    char command[BUFFER_SIZE];
    
    //vsearch 1.dereplication; 2.denoise; 3.nonchimeras; 4.db
	string fir_name;
	fir_name="dereplication";
    
	//v1:dereplication
	sprintf(command,"%s --derep_fulllength %s --sizeout --output %s/%s --minuniquesize 1",programname.c_str(),infilename.c_str(),outpath.c_str(),fir_name.c_str());
    system(command);
    //cout<< command << endl;
    
    string sec_name;
    if(Is_denoised == 'T'){//=true,denoise 
    	sec_name="denoised";
    	//v2:denoise
    	sprintf(command,"%s --cluster_unoise %s/%s --sizein --sizeout --centroids %s/%s --minsize 1",programname.c_str(),outpath.c_str(),fir_name.c_str(),outpath.c_str(),sec_name.c_str());
    	system(command);
    	//cout<< command << endl;
	}else{
		sec_name=fir_name;
	}
	
	string thi_name;
	if(Is_nonchimeras == 'T'){//=true, remove chimeras
		thi_name="nonchimeras";
		//v3:nonchimeras
    	sprintf(command,"%s --uchime3_denovo %s/%s --sizein --sizeout --nonchimeras %s/%s",programname.c_str(),outpath.c_str(),sec_name.c_str(),outpath.c_str(),thi_name.c_str());
    	system(command);
    	//cout<< command << endl;
	}else{
		thi_name=sec_name;
	}

    //v4:global search db, output format is sam 
    sprintf(command,"%s --id 0.97 --db %s --usearch_global %s/%s --samout %s/map_output.txt",programname.c_str(),database_path.c_str(),outpath.c_str(),thi_name.c_str(),outpath.c_str()); 
    system(command);
    //cout<< command << endl;
    
    cout << "Mapping Finished" << endl ;   
    return seq_n;
    }

int Parallel_Align_Paired(string programname, string infilename_1, string infilename_2, string outpath, string database_path, char Is_denoised, char Is_nonchimeras, string other_args){
    
    cout << "Mapping starts" << endl;
        
    int seq_n_1 = Get_Count_fastq(infilename_1.c_str());  
    int seq_n_2 = Get_Count_fastq(infilename_2.c_str());
	  
    if (seq_n_1 != seq_n_2) return -1;
    
    cout << "There are " << seq_n_1 << " paired sequences in total" << endl << endl;
    
    mkdir((outpath + "/maptemp").c_str(), 0755);
    
    //command
    
    char command[BUFFER_SIZE];
    
    //vsearch 1.merge; 3.dereplication; 4.denoise; 5.nonchimeras; 6.db
    //v1:merge
	sprintf(command,"%s --fastq_mergepairs %s --reverse %s --fastqout %s/merged.fastq",programname.c_str(),infilename_1.c_str(), infilename_2.c_str(),outpath.c_str()); 
	system(command);
	//cout<< command << endl;
	
	//v3:dereplication
	string fir_name;
	fir_name="dereplication";
	sprintf(command,"%s --derep_fulllength %s/merged.fastq --sizeout --output %s/%s --minuniquesize 1",programname.c_str(),outpath.c_str(),outpath.c_str(),fir_name.c_str());
    system(command);
    //cout<< command << endl;
    
    //v4:denoise
	string sec_name;
    if(Is_denoised == 'T'){//=true,denoise 
    	sec_name="denoised";
    	sprintf(command,"%s --cluster_unoise %s/%s --sizein --sizeout --centroids %s/%s --minsize 1",programname.c_str(),outpath.c_str(),fir_name.c_str(),outpath.c_str(),sec_name.c_str());
    	system(command);
    	//cout<< command << endl;
	}else{
		sec_name=fir_name;
	}
	
	//v5:nonchimeras
	string thi_name;
	if(Is_nonchimeras == 'T'){//=true, remove chimeras
		thi_name="nonchimeras";
    	sprintf(command,"%s --uchime3_denovo %s/%s --sizein --sizeout --nonchimeras %s/%s",programname.c_str(),outpath.c_str(),sec_name.c_str(),outpath.c_str(),thi_name.c_str());
    	system(command);
    	//cout<< command << endl;
	}else{
		thi_name=sec_name;
	}

    //v6:global search db, output format is sam 
    sprintf(command,"%s --id 0.97 --db %s --usearch_global %s/%s --samout %s/map_output.txt",programname.c_str(),database_path.c_str(),outpath.c_str(),thi_name.c_str(),outpath.c_str()); 
    system(command);
    //cout<< command << endl;
   
    cout << "Mapping Finished" << endl ;   
    return seq_n_1;
    }

#endif
