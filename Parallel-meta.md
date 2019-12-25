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

	brew install gcc

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

	tar –xzvf parallel-meta-3.tar.gz

b. Install
	
	cd parallel-meta

	source install.sh

### Tips for the Automatic installation

1. Please “cd parallel-meta” directory before run the automatic installer.
2. The automatic installer only configures the environment variables to the default configuration files of “~/.bashrc” or “~/.bash_profile”. If you want to configure the environment variables to other configuration file please use the manual installation.
3. If the automatic installer failed, Parallel-META 3 can still be installed manually by the following steps. 

## Manual installation

If the automatic installer failed, Parallel-META 3 can still be installed manually. 

a. Extract the package:

	tar –xzvf parallel-meta-3.tar.gz

b. Configure the environment variables (default environment variable configuration file is located at “~/.bashrc” or “~/.bash_profile”) 

	export ParallelMETA=Path to Parallel-META 3
	export PATH=”$PATH:$ParallelMETA/bin”
	source ~/.bashrc

c. Install R packages
	
	Rscript $ParallelMETA/Rscript/config.R

d. Compile the source code* (only required by the source code package): 

	cd parallel-meta
	make

# Notice before start to use

1. The output path should NOT be the same path as the input file for the output path will be CLEARED initially. Make sure Parallel-META 3 has the write permission of the output path.
2. We strongly recommend to read this manually carefully before use ParallelMETA 3. 

# Tools in toolkit

Tools can be directly used as Linux command line with parameters. To see all available parameters, please run the command with parameter ‘-h’, eg. 

	PM-pipeline –h 

## PM-pipeline: automatic pipeline 

The PM-pipeline is an integrated automatic pipeline for multiple sample analysis with most process steps in Parallel-META 3. This analysis can either start from sequence (by –i) or start from profile results (by
-l for sample list,
-T for OTU table). 

**Usage:**

	PM-pipeline [Option] value

	[Options]:
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level)), or E (SILVA (18S rRNA, 97% level)), or T (ITS (ITS1, 97% level)) 
		-m Meta data file [Required] (See Meta-data format)
		
	Input options:
		-i Sequence list file, pair-ended sequences are supported [Conflicts with l] (See Sequence format and sequence list)
		-p List file path prefix [Optional for -i]
		or 
		-l Taxonomic analysis results list [Conflicts with -i] (See Single_Sample.List)
		-p List file path prefix [Optional for -l]
		or
		-T (upper) Input OTU count table (*.OTU.Count) [Conflicts with -i] (See Abundance table)
	
	Profiling parameters:
		-M (upper) Sequence type, T (Shotgun) or F (rRNA), default is F
		-e Alignment mode, 0: very fast, 1: fast, 2: sensitive, 3: very-sensitive, default is 3
		-P (upper) Pair-end sequence orientation, 0: Fwd & Rev, 1: Fwd & Fwd, 2: Rev & Fwd, default is 0
		-r rRNA copy number correction, T(rue) or F(alse), default is T
		-a rRNA length threshold of rRNA extraction. 0 is disabled, default is 0 [optional for -M T]
		-k Sequence format check, T(rue) or F(alse), default is F
		-f Functional analysis, T(rue) or F(alse), default is T
	
	Statistic parameters:
		-L (upper) Taxonomical levels (1-6: Phylum - Species). Multiple levels are accepted
		-w Taxonomical distance type, 0: weighted, 1: unweigthed, 2: both, default is 2
		-F (upper) Functional levels (Level 1, 2, 3 or 4 (KO number)). Multiple levels are accepted
		-s Sequence number normalization depth, 0 is disabled, default is disable
		-b Bootstrap for sequence number normalization, default is 200, maximum is 1000
		-R (upper) Rarefaction curve, T(rue) or F(alse), default is F
		-E (upper) If the samples are paired, T(rue) or F(alse), default is F
		-C (upper) Cluter number, default is 2
		-G (upper) Network analysis edge threshold, default is 0.5
	
	Other options:
		-t cpu core number, default is auto
		-h Help
		
Notice:
1. Pair-ended sequences are supported for 16S rRNA sequences (See Sequence format and sequence list).
2. Samples (pairs) should be in the same order in all lists and meta-data.
3. In Meta data file, sample IDs should not be started with number, and should not contain space symbol (‘ ‘) and table symbol (‘\t’) (See Meta-data format).
4. Rarefaction curve is disabled in default setting, use “–R T” to enable (might be slow).
5. Sequence number normalization is disabled in default setting, use “-s” to enable and set the normalization depth (might drop samples with sequence number less than the setting depth). 

## PM-parallel-meta: sequence profiling 

