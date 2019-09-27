// Updated at Dec 26, 2018
// Updated by Xiaoquan Su
// Bioinformatics Group, Single-Cell Research Center, QIBEBT, CAS
// version 3.1 or above with _Table_Format

#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <math.h>

#include "hash.h"
#include "utility.h"
#include "db.h"

#include "table_format.h"
#include "dist.h"

#ifndef COMP_FUNC_H
#define COMP_FUNC_H

using namespace std;

//#define GeneN 6909

class _Comp_Tree_Func{
      
      public:
             _Comp_Tree_Func(){                                                              
                               GeneN = Load_Id();                        
                               }
             _Comp_Tree_Func(char db){
                               Database.Set_DB(db);
                               if (!Database.Get_Is_Func()){
                                                            cout << "The " << Database.Get_Description() << " domain is not supported yet" << endl;
                                                            exit(0);
                                                            }                                                             
                               GeneN = Load_Id();                               
                               }
    
             int Load_Gene_Count(const char * infilename, float * abd);
             int Load_Gene_Count(_Table_Format * table, float * abd, int sample);
             float Calc_sim(float * abd_m, float * abd_n, int mode);
             //float Calc_Dist_Cos(float * abd_m, float * abd_n);
             //float Calc_Dist_E(float * abd_m, float * abd_n); //Weighted Euclidean dist
             
             int Get_GeneN(){
                 return GeneN;
                 }
             
      private:
              int Load_Id();
              
              vector <string> Gene;
              _PMDB Database;
              int GeneN;              
      };

int _Comp_Tree_Func::Load_Gene_Count(const char * infilename, float * abd){
    
    memset(abd, 0, GeneN * sizeof(float));
    
    hash_map<string, float, std_string_hash> table;
    
    ifstream infile(infilename, ifstream::in);
    if (!infile){
                 cerr << "Error: Cannot open input file : " << infilename << endl;
                 exit(0);
                 }
    
    int count = 0;
    string buffer;
    getline(infile, buffer);//title
    while(getline(infile, buffer)){                          
                          stringstream strin(buffer);  
                          string gene;
                          string temp;
                          float gene_count;
        
                          strin >> gene >> gene_count;
                          
                          if (table.count(gene) == 0)
                                                table[gene] = gene_count;
                          else table[gene] += gene_count; 
                          count ++;
                          }
    
    for (int i = 0; i < GeneN; i ++){
        abd[i] = 0;
        if (table.count(Gene[i]) != 0)
           abd[i] = table[Gene[i]];
        }
                 
    infile.close();
    infile.clear();
    
    return count;
    }

int _Comp_Tree_Func::Load_Gene_Count(_Table_Format *table, float * abd, int sample){
    
    memset(abd, 0, GeneN * sizeof(float));
    
    int count = 0;
    
    for (int i = 0; i < GeneN; i ++){
        abd[i] = table->Get_Abd_By_Feature(sample, Gene[i]);
        if (abd[i] > 0) count ++;
        }
    return count;
    }

float _Comp_Tree_Func::Calc_sim(float * abd_m, float * abd_n, int mode){
      
      switch (mode) {
             
             case 1: return 1.0 - Calc_Dist_E(abd_m, abd_n, GeneN); break;
             case 2: return 1.0 - Calc_Dist_JSD(abd_m, abd_n, GeneN); break;
             default: 
             case 0: return 1.0 - Calc_Dist_Cos(abd_m, abd_n, GeneN); break;
             }
      return 0;
      }
/*
float _Comp_Tree_Func::Calc_Dist_Cos(float * abd_m, float * abd_n){
      
      return Calc_Dist_Cos(abd_m, abd_n, GeneN);
      
      }

float _Comp_Tree_Func::Calc_Dist_E(float * abd_m, float * abd_n){
      
      return Calc_Dist_E(abd_m, abd_n, GeneN); 
      
      }
*/
int _Comp_Tree_Func::Load_Id(){
    
    ifstream in_idfile(Database.Get_Func_Id().c_str(), ifstream::in);
    if (!in_idfile){
                    cerr << "Error: Open KO ID file error : " << Database.Get_Func_Id() << endl;
                    return 0;
                    }
    string buffer;
    int count = 0;
    while(getline(in_idfile, buffer)){
                          if (buffer.size() == 0) continue;
                          Gene.push_back(buffer);
                          count ++;
                          }
    in_idfile.close();
    in_idfile.clear();
    
    return count;
    }

#endif
