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

The PM-parallel-meta is the profiling tool for sequences. It accepts single shotgun sequences or 16S/18S rRNA sequences in FASTA or FASTQ format for taxonomical and predictive functional profiling.

**Usage:**

	PM-parallel-meta [Option] Value

	Options: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level)), or E (SILVA (18S rRNA, 97% level)), or T (ITS (ITS1, 97% level))

	[Input options, required]
		-m Input single sequence file (Shotgun) [Conflicts with -r and -R]
	      or
		-r Input single sequence file (rRNA targeted) [Conflicts with -m]
	  	-R (upper) Input paired sequence file [Optional for -r, Conflicts with -m]
	  	-P (upper) Pair-end sequence orientation for -R
	     	   0: Fwd & Rev, 1: Fwd & Fwd, 2: Rev & Fwd, default is 0
	
	[Output options]
	  	-o Output path, default is "Result"
	
	[Other options]
	  	-e Alignment mode
	     	   0: very fast, 1: fast, 2: sensitive, 3: very-sensitive, default is 3
	  	-k Sequence format check, T(rue) or F(alse), default is F
	  	-L (upper) rRNA length threshold of rRNA extraction. 0 is disabled, default is 0 [Optional for -m, Conflicts with -r]
	  	-f Functional analysis, T(rue) or F(alse), default is T
	  	-t Cpu core number, default is auto
	 	-h Help

Example:

	PM-parallel-meta –m meta.fasta –o metaresults –l 150

## PM-format-seq: sequence format checking and re-formatting

The PM-format-seq check the input sequence format (See Sequence format), and try to re-reformat the invalid input sequence file(s) with making a backup. 

**Usage:**

	PM-format-seq [Option] Value
	
	Options: 
	
	[Input options, required]
	  	-i Input single sequence file in FASTA or FASTQ format
	      or
	  	-l Input sequence files list
	  	-p List file path prefix for '-l' [Optional for -l]

	[Other options]
	  	-h Help

Example:

	PM-format-seq –i sample.fasta

or

	PM-format-seq –l list.txt 

## PM-extract-rna: extracts the rRNA fragments from shotgun sequences 

The PM-extract-rna can extract 16S & 18S rRNA fragments from shotgun sequences. This function has already been included in PM-parallel-meta with parameter “-m” for shotgun sequences. 

**Usage:**

	PM-extract-rna [Option] Value

	Options:
		-D (upper) Domain, B (Bacteria, 16S rRNA) or E (Eukaryote, 18S rRNA), default is B
	
	[Input options, required]
	  	-m or -i Input single sequence file (Shotgun)
	
	[Output options]
	  	-o Output Path, default is "Extract_RNA"
	
	[Other options]
	  	-l rRNA length threshold of rRNA extraction. default is 0
	  	-t Cpu core number, default is auto
	  	-h Help


Example:

	PM-extract-rna –m examples/meta.fasta –o metaresults –e 1e-20 –l 150 

## PM-plot-taxa: taxonomy profile visualization by Krona

The PM-plot-taxa has already been integrated in program PM-parallel-meta.

**Usage:**

	PM-plot-taxa [Option] Value
	Options: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level)), or E (SILVA (18S rRNA, 97% level)), or T (ITS (ITS1, 97% level))

	[Input options, required]
	  	-i Input single file
	      or
	  	-l Input files list
	  	-p List file path prefix [Optional for -l]
	      or
	  	-T (upper) Input OTU count table (*.OTU.Count)

	[Output options]
	  	-o Output Path, default is "Result_Plot"

	[Other options]
	  	-r rRNA copy number correction, T(rue) or F(alse), default is T
	  	-h Help

Example:

	PM-plot-taxa –l list.txt –o result_plot

or

	PM-plot-taxa –T Sample.OTU.Abd –o result_plot 

## PM-predict-func: function prediction from taxonomy profiles 

The PM-predict-func has already been integrated in program PM-parallel-meta.  

**Usage:**

	PM-predict-func [Option] Value

	Options: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level))

	[Input options, required]
		-i Input single file
	      or
		-l Input files list
		-p List file path prefix [Optional for -l]
	      or
		-T (upper) Input OTU count table (*.OTU.Count)

	[Output options]
		-o Output path, default is "Results_Func"
		-L (upper) If output list (at "Output_path/func.list"), T(rue) or F(alse), default is T [optional for -l]

	[Other options]
		-t Cpu core number, default is auto
	 	-h Help

Example:

	PM-predict-func –l list.txt –o result_func 

or

	PM-predict-func –T Sample.OTU.Count –o result_func

## PM-predict-func-nsti: NSTI calculation for functional prediction

For NSTI (Nearest Sequenced Taxon Index) value calculation of functional analysis. The PM-predict-func-nsti has already been integrated in program PMparallel-meta.

**Usage:**

	PM-predict-func-nsti [Option] Value

	Options: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level))

	[Input options, required]
		-i Input single file
	      or
		-l Input files list
		-p List file path prefix [Optional for -l]
	      or
		-T (upper) Input OTU count table (*.OTU.Count)

	[Output options]
		-o Output file, default is "NSTI.out"
	
	[Other options]
		-t Cpu core number, default is auto
		-h Help

Example:

	PM-predict-func-nsti –l list.txt –o result_func 

or

	PM-predict-func-nsti –T Sample.OTU.Count –o result_func

## PM-predict-func-contribute: contribution evaluation of OTUs for functional profiles (new) 

For evaluation of OTUs to functional profiles.

**Usage:**

	PM-predict-func-contribute [Option] Value

	Options: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level))

	[Input options, required]
		-i Input single file
	      or
		-l Input files list
		-p List file path prefix [Optional for -l]
	      or
		-T (upper) Input OTU count table (*.OTU.Count)

	[Output options]
		-L (upper) Selected KO list
		-o Output file name, default is "func.KO.contribute"

	[Other options]
		-t Cpu core number, default is auto
		-h Help

Example:

	PM-predict-func-contribute –T Sample.OTU.Count –L ko.list 

## PM-select-taxa: makes OTU/taxa feature tables 

Used for multi-sample feature selection (with a specified taxonomical level) based on the taxonomical profiling results.

**Usage:**

	PM-select-taxa [Option] Value

	Option: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level)), or E (SILVA (18S rRNA, 97% level)), or T (ITS (ITS1, 97% level))

	[Input options, requried]
		-l Input files list
		-p List file path prefix for '-l' [Optional for -l]
	      or
		-T (upper) Input OTU count table (*.OTU.Count)

	[Output options]
		-o Output file name, default is "taxaonomy_selection"
		-L (upper) Taxonomical level (1-6: Phylum - Species, 7: OTU). default is 5
		-P (upper) Print distribution barchart, T(rue) or F(alse), default is F

	[Other options]
		-r rRNA copy number correction, T(rue) or F(alse), default is T
		-q Minimum sequence count threshold, default is 2
		-m Maximum abundance threshold, default is 0.001 (0.1%)
		-n Minimum abundance threshold, default is 0.0 (0%)
		-z Minimum No-Zero abundance threshold, default is 0.1 (10%)
		-v Minimum average abundance threshold, default is 0.001 (0.1%)
		-h Help

Example:

	PM-select-taxa –l list.txt –o taxa.txt –L 6

or

	PM-select-taxa –T Sample.OTU.Count –o taxa.txt –L 6

## PM-select-func: makes functional feature tables

For multi-sample feature selection (with a specified KEGG pathway level and relative abundance) based on the functional profiling results.

**Usage:**

	PM-select-func [Option] Value

	Options: 
	
	[Input options, required]
		-l Input files list [Conflicts with -T and -B]
		-p List file path prefix [Optional for -l]
	      or
		-T (upper) Input KO Absolute Count table (*.KO.Count) [Conflicts with -l and -B]

	[Output options]
	  	-o Output file, default is "functions_category"
	  	-L (upper) KEGG Pathway level, Level 1, 2, 3 or 4 (KO number), default is 2
	  	-P (upper) Print distribution barchart, T(rue) or F(alse), default is F

	[Other options]
	  	-h Help

Example:

	PM-select-func –l list.txt –o func.txt –L 2 

or

	PM-select-func –T Sample.KO.Count –o func.txt –L 2 

## PM-comp-taxa: calculates similarity/distance among samples by OTU profiles

For multi-sample comparison & similarity (distance) calculation based on the taxonomical profiling results

**Usage:**

	PM-comp-taxa [Option] Value

	Options: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level)), or E (SILVA (18S rRNA, 97% level)), or T (ITS (ITS1, 97% level))

	[Input options, required]
	  	-i Two samples path for single sample comparison
	      or
	 	-l Input files list for multi-sample comparison
	  	-p List files path prefix [Optional for -l]
	      or
	  	-T (upper) Input OTU count table (*.OTU.Count) for multi-sample comparison

	[Output options]
	  	-o Output file, default is to output on screen
	  	-d Output format, distance (T) or similarity (F), default is T
	  	-P (upper) Print heatmap and clusters, T(rue) or F(alse), default is F

	[Other options]
	  	-M (upper) Distance Metric, 0: Meta-Storms; 1: Meta-Storms-unweighted; 2: Cosine; 3: Euclidean; 4: Jensen-Shannon; 5: Bray-Curtis, default is 0
	  	-r rRNA copy number correction, T(rue) or F(alse), default is T
	  	-c Cluster number, default is 2 [Optional for -P]
	  	-t Cpu core number, default is auto
	  	-h Help

Example:

	PM-comp-taxa –l list.txt –o sim_matrix.txt –t 8

or

	PM-comp-taxa –T Sample.OTU.Abd –o sim_matrix –t 8

## PM-comp-func: calculates similarity/distance among samples by functional profiles

For multi-sample comparison & similarity (distance) calculation based on the functional profiling results. 

**Usage:**

	PM-comp-func [Option] Value

	Options: 
	
	[Input options, required]
	  	-i Two samples path for single sample comparison
	      or
	  	-l Input files list table for multi-sample comparison
	  	-p List file path prefix [Optional for -l]
	      or
	  	-T (upper) Input KO count table (*.KO.Count) for multi-sample comparison
	
	[Output options]
	  	-o Output file, default is to output on screen
	  	-d Output format, distance (T) or similarity (F), default is T
	  	-P (upper) Print heatmap and clusters, T(rue) or F(alse), default is F

	[Other options]
	  	-M (upper) Distance Metric, 0: Cosine; 1: Euclidean; 2: Jensen-Shannon; 3: Bray-Curtis, default is 0
	  	-c Cluster number, default is 2 [Optional for -P]
	  	-t Cpu core number, default is auto
	  	-h Help

Example:

	PM-comp-func –l list.txt –o sim_matrix.txt –t 8 

or

	PM-comp-func –T Sample.KO.Abd –o sim_matrix.txt –t 8 

## PM-rand-rare: rarefy samples by taxonomy profiles 

**Usage:**

	PM-rand-rare [Option] Value

	Options: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level)), or E (SILVA (18S rRNA, 97% level)), or T (ITS (ITS1, 97% level))

	[Input options, required]
	  	-i Input single file name
	      or
	 	-l Input files list
	  	-p List file path prefix [Optional or -l]
	      or
	  	-T (upper) Input OTU count table (*.OTU.Count)

	[Output options]
	  	-o Output path (for -i and -l) or output table name (for -T), default is "Rare_Out"
	  	-L (upper) If output list, T(rue) or F(alse), default is T [optional for -l]

	[Other options]
	  	-s Rarefaction depth [Required]
	  	-b Bootstrap for sequence number normalization, default is 200, maximum is 1000
	  	-h Help

Example:

	PM-rand-rare –i taxa.Count –o taxa.rare.Count –s 1000

## PM-rare-curv: plots the rarefaction curves by OTU table

Used for rarefaction analysis and rarefaction curves printing to pdf format. 

**Usage:**

	PM-rare-curv [Option] Value

	Options: 

	[Input options, required]
	  	-i or -T (upper) Input feature count table (*.OTU.Count)

	[Output options]
	  	-o Output file directory, default is "result"
	  	-p Prefix name of output, default is "out"

	[Other options]
	  	-b The bootstrap value, default is 20
	  	-s The rarefaction step, default is 100
	  	-l The rarefaction curve label, T is enable and F is disable, default is F
	  	-t Cpu core number, default is auto
	  	-h Help

Example:

	PM-rare-curv –i taxa.Count –o rare-out –b 20 

## PM-comp-corr: calculates the correlation among OTUs

Used for correlation calculation of taxonomical and functional distribution with meta-data. 

The PM-comp-corr accepts the results of PM-select-taxa and PM-select-func.

**Usage:**

	PM-comp-corr [Option] Value

	Options: 
	
	[Input options, required]
	  	-i or -T (upper) Input feature table file (*.Abd)
	  	-m Meta data name [Optional]
	  	-c Selected feature, separated by "," [Optional for -m]

	[Output options]
	  	-o Output prefix, default is "corr_matrix"

	[Other options]
	  	-f 0:(Spearman) or 1:(Pearson) metrics,default is 0
	  	-N (upper) Network based co-occurrence analysis, T(rue) or F(alse), default is F
	  	-G (upper) Netowrk analysis threshold, default is 0.5
	  	-t Cpu core number, default is auto
	  	-h Help

Example:

	PM-comp-corr –i taxa.txt –o taxa.network.txt

## PM-split-seq: split sequences by sample 

Used for sequence split by barcode or group information (Mothur format). 

The PM-split-seq accepts the input sequence in FASTA or FASTQ format, and also is compatible with QIIME format FASTQ files.

**Usage:**

	PM-split-seq [Option] Value

	Options: 
	
	[Input options, required]
	  	-i Input sequence file in FASTA or FASTQ format [Required]
	  	-b Input barcode file [Conflicts with -g and -q]
	      or
	  	-g Input group file [Conflicts with -b and -q]
	      or
	  	-q T or F, if the input in QIIME format [Conflicts with -g and -b]

	[Output options]
	  	-o Result output path, default is "Out"

	[Other options]
	  	-h Help

Example:

	PM-split-seq –i seq.fa –b barcode.txt –o seq.out	
	PM-split-seq –i seq.fa –g seq.groups –o seq.out
	PM-split-seq –i seq.fa –q T –o seq.out

## PM-update-taxa: update the taxonomy annotation to latest version 

Used for taxonomy annotation update to 3.3.1 from 3.0-3.3. Notice that this is not compatible with version 2.X or lower.

**Usage:**

	PM-update-taxa [Option] Value

	Options: 
		-D (upper) ref database, default is G (GreenGenes-13-8 (16S rRNA, 97% level)), or S (SILVA (16S rRNA, 97% level)), or O (Oral_Core (16S rRNA, 97% level)), or E (SILVA (18S rRNA, 97% level)), or T (ITS (ITS1, 97% level))

	[Input options, required]
	  	-i Input single file
	      or
	  	-l Input files list
	  	-p List file path prefix [Optional for -l]

	[Other options]
	  	-h Help

Example:

	PM-update-tax –l list.txt

in which “list.txt” is the path of N samples’ taxonomical analysis results, and each sample in one line (see Sample list format).

The PM-update-taxa will replace the previous analysis results in “classification.txt”, and backup previous file named “classification.txt.bk”. This update will significantly improve the taxonomy annotation on Genus level, so we strongly command to re-run the pipeline. This update will not affect the results of functional analysis.

# Name change of tools 

From version 3.5, some binary file names have been changed for easy understanding:

Previous name|New name|Description
:------------|:-------|:----------
*PM-class-tax|*PM-plot-taxa|taxonomy profile visualization by Krona
:------------|:------------|:--------------------------------------


