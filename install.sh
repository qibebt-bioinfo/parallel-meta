###Parallel-META 3 BIOM plugin installer
###Bioinformatics Group, Single-Cell Research Center, QIBEBT, CAS
###Updated at Jan 30, 2019 
###Updated by Xiaoquan Su, Honglei Wang
###Checking that environment variable of Parallel-META exists###
Check_pm=$ParallelMETA
echo "**Parallel-META 3 BIOM plugin Installation**"
echo "**version 3.5**"
###Build source code for src package###
echo -e "\n**Parallel-META 3 BIOM plugin src package**"
make
echo -e "\n**Build Complete**"
###Installation to Parallel-META 3 directory###
if [ "$Check_pm" == "" ]
   then
      echo -e "\n Parallel-META 3 undetected, please install Parallel-META 3 first"
   else
       cp bin/* $ParallelMETA/bin  
fi
echo -e "\n**Parallel-META 3 BIOM plugin Installation Complete**"
echo -e "\n**You can use PM-biom-to-table to convert BIOM file into Parallel-META 3 format**"
