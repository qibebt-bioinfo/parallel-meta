# Parallel-META 3 users’ manual 

![Version](https://img.shields.io/badge/Version-3.5.3-brightgreen)
![Release date](https://img.shields.io/badge/Release%20date-Dec.%2025%2C%202019-brightgreen)


# Introduction

Parallel-META is a comprehensive and full-automatic computational toolkit for rapid data mining among metagenomic datasets, with advanced features including sequence profiling and OTU picking, rRNA copy number calibration, functional prediction, diversity statistics, bio-marker selection, interaction network construction, vector-graph-based visualization and parallel computing. Both metagenomic shotgun sequences and 16S/18S rRNA amplicon sequences are accepted. 
 
Based on parallel algorithms and optimizations, Parallel-META 3 can achieve a very high speed compare to traditional microbiome analysis pipelines. 
 
We strongly recommend that read this manually carefully before use ParallelMETA 3.

# Download
	
The latest release is available at: 

http://bioinfo.single-cell.cn/parallel-meta.html 

# Packages 

## Executive binary package:

Parallel-META 3 executive binary package integrated with all tools is available for Linux and Mac OS X. 

## Source code package: 

Parallel-META 3 source code package is also available for building and installation for other Unix/Linux based operating systems.

# Dependency

## OpenMP

OpenMP library is the C/C++ parallel computing library. Most Linux releases have OpenMP already been installed in the system. In Mac OS X, to install the compiler that supports OpenMP, we recommend using the Homebrew package manager:

*brew install gcc*

## Rscript environment 

For statistical analysis and pdf format output, Parallel-META 3 requires cran-R (<http://cran.r-project.org/>) 3.2 or higher for the execution of “.R” scripts. Then all packages could be automatically installed and updated by the Parallel-META 3 installer.

## Bowtie2 (2.1.0 or higher, included in the package)

Bowtie2 has been integrated in the package. If you want to install/update manually, please download from 

<http://sourceforge.net/projects/bowtie-bio/files/bowtie2/>

and put the “bowtie-align-s”to $ParallelMETA/Aligner/bin/. 

## HMMER 3 (3.0 or higher, included in the package) 

HMMER3 has been integrated in the package. If you want to install/update manually, please download from 

<http://www.hmmer.org/download.html>

and put the “hmmsearch” to $ParallelMETA/HMMER/bin/.

# Installation

## Automatic installation (recommended)

Now the Parallel-META provides a fully automatic installer for easy installation.

a. Extract the package: 

	*tar –xzvf parallel-meta-3.tar.gz*

b. Install
	
	*cd parallel-meta*

	*source install.sh*

### Tips for the Automatic installation

1. Please “cd parallel-meta” directory before run the automatic installer.
2. The automatic installer only configures the environment variables to the default configuration files of “~/.bashrc” or “~/.bash_profile”. If you want to configure the environment variables to other configuration file please use the manual installation.
3. If the automatic installer failed, Parallel-META 3 can still be installed manually by the following steps. 

## Manual installation

If the automatic installer failed, Parallel-META 3 can still be installed manually. 

a. Extract the package:

	*tar –xzvf parallel-meta-3.tar.gz*

b. Configure the environment variables (default environment variable configuration file is located at “~/.bashrc” or “~/.bash_profile”) 

	*export ParallelMETA=Path to Parallel-META 3*
	*export PATH=”$PATH:$ParallelMETA/bin” 
	*source ~/.bashrc*

c. Install R packages
	
	*Rscript $ParallelMETA/Rscript/config.R*

d. Compile the source code* (only required by the source code package): 

	*cd parallel-meta*
	*make*

# Notice before start to use

1. The output path should NOT be the same path as the input file for the output path will be CLEARED initially. Make sure Parallel-META 3 has the write permission of the output path.
2. We strongly recommend to read this manually carefully before use ParallelMETA 3. 

# Tools in toolkit 
