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
PM-class-tax|PM-plot-taxa|taxonomy profile visualization by Krona
PM-class-func|PM-predict-func|function prediction from taxonomy profiles
PM-class-func-nsti|PM-predict-func-nsti|NSTI calculation for functional prediction
PM-taxa-sel|PM-select-taxa|makes OTU/taxa feature tables
PM-func-sel|PM-select-func|makes functional feature tables
PM-comp-sam|PM-comp-taxa|calculates similarity/distance among samples by OTU profiles
PM-comp-sam-func|PM-comp-func|calculates similarity/distance among samples by functional profiles

# R scripts

R scripts can be used with R command “Rscript” with parameters. To see all available parameters, please run the script with parameter ‘-h’, eg.

	Rscript $ParallelMETA/Rscript/PM_Pcoa.h -h

## PM_Config.R: checks and installs R packages

Used for installing the R package dependency and checking environment variable configuration.

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Config.R

## PM_Distribution.R: plots bar chart by OTU table

Used for taxa/pathway abundance distribution barchart printing to pdf format. This function has also been integrated in PM-select-taxa and PM-select-func by parameter “-p”.

PM_Distribution.R accepst the relative abundance table (*.Abd) results form PM-select-taxa and PM-select-func. (see Abundance tables)

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Distribution.R [Option] Value

	[Options]
		-i ABUND_FILE, --abund_file=ABUND_FILE
			Input feature table with Relative Abundance [Required] (See Abundance table)
		-m META_DATA, --meta_data=META_DATA
					Input meta data file [Optional]
		-o OUT_DIR, --out_dir=OUT_DIR
				Output directory [default Distribution]
		-p PREFIX, --prefix=PREFIX
			Output file prefix [default Out]
		-t THRESHOLD, --threshold=THRESHOLD
				Average value threshold [Optional, default 0.01]
		-h Or --help. Show this help message and exit

## PM_Heatmap.R: plots heatmap chart by similarity matrix

Used for heatmap figure printing to pdf format. This function has also been integrated in PM-comp-taxa and PM-comp-func by parameter “-p”.

PM_Heatmap.R accepts the output results of PM-comp-taxa and PM-compfunc.

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Heatmap.R [Option] Value

	[Options]
		-d DIST_FILE, --dist_file=DIST_FILE
			Input distance matrix file [Required].
		-o OUTFILE, --outfile=OUTFILE
			Output heatmap [default heatmap.pdf]
		-h Or --help. Show this help message and exit

## PM_Hcluster.R: for clustering of samples by distance matrix

For hierarchical clustering and printing to pdf format. This function has also been integrated in PM-comp-taxa and PM-comp-func by parameter “-p”.

PM_Hcluster.R accepts the output results of PM-comp-taxa and PM-comp-func.

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Hcluster.R [Option] Value
	
	[Options]
		-d DIST_FILE, --dist_file=DIST_FILE
			Input distance matrix file [required].
		-o OUTFILE, --outfile=OUTFILE
			Output file [default hcluster.pdf]
		-c GROUPNUM, --groupNum=GROUPNUM
			Number of groups to rect [default 2]
		-h Or --help. Show this help message and exit

## PM_Pcoa.R: PCoA analysis by distance matrix

For PCoA (Principle Co-ordinate Analysis) based on the distance matrix and results printing to pdf format.

PM_Pcoa.R accepts the output results that generated by PM-comp-taxa and PM-comp-func.

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Pcoa.R [Option] Value

	[Options]
		-d DIST_FILE, --dist_file=DIST_FILE
			Input distance matrix file [Required].
		-m META_DATA, --meta_data=META_DATA (See Meta-data format)
			Input meta-data file [Required].
		-l DRAWLABEL, --drawlabel=DRAWLABEL
			If enable the sample label [Optional, default FALSE]
		-o OUTFILE, --outfile=OUTFILE
			Output PCoA [default pcoa.pdf]
		-p POINTSIZE, --pointsize=POINTSIZE
			Point size on PCoA plot [default 6]
		-h Or --help. Show this help message and exit

## PM_Pca.R: PCA analysis by OTU table

For PCA (Principle Component Analysis) based on the abundance table and results printing to pdf format. PM_Pca.R accepts the output results of PM-selecttaxa and PM-select-func. (see Abundance_Tables)

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Pca.R [Option] Value

	[Options]
		-i ABUND_FILE, --abund_file=ABUND_FILE
			Input feature table with Relative Abundance (*.Abd) [Required]. (See Abundance table)
		-m META_DATA, --meta_data=META_DATA (See Meta-data format)
			Input meta-data file [Required].
		-l DRAWLABEL, --drawlabel=DRAWLABEL
			If enable the sample label [Optional, default FALSE]
		-o OUTFILE, --outfile=OUTFILE
			Output PCA figure [default pca.pdf]
		-p POINTSIZE, --pointsize=POINTSIZE
			Point size on PCA plot [default 6]
		-h Or --help. Show this help message and exit

## PM_Adiversity.R: alpha diversity analysis by OTU table

Used for multivariate statistical analysis of alpha diversity based on the sequence count table. PM_Adiversity.R accepts the absolute count table (*.Count) results of PM-select-taxa and PM-select-func. (see Abundance_Tables)

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Adiversity.R [Option] Value
	
	[Options]
		-i TABLE_FILE, --table_file=TABLE_FILE
			Input feature table with read count (*.Count) or abundance (*.Abd) [Required] (See Abundance table)
		-m META_DATA, --meta_data=META_DATA (See Meta-data format)
			Input meta-data file [Required].
		-o OUT_DIR, --out_dir=OUT_DIR
			Output directory [default Alpha_diversity]
		-w WIDTH, --width=WIDTH
			Width of figure [default 10]
		-p PREFIX, --prefix=PREFIX
			Output file prefix [Optional, default Out]
		-h Or --help. Show this help message and exit

## PM_Bdiversity.R: beta diversity analysis by distance matrix

Used for multivariate statistical analysis of beta diversity based on the distance matrix. PM_Bdiversity.R accepts the output results of PM-comp-taxa and PM-compfunc.

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Bdiversity.R [Option] Value

	[Options]
		-d DIST_FILE, --dist_file=DIST_FILE
			Input distance matrix table [Required].
		-m META_DATA, --meta_data=META_DATA (See Meta-data format)
			Input meta-data file [Required].
		-o OUT_DIR, --out_dir=OUT_DIR
			Output directory [default Beta_Diversity].
		-p PREFIX, --prefix=PREFIX
			Output file prefix [Optional, default Out]
		-n DIST_NAME, --dist_name=DIST_NAME
			The distance metrics name such as Meta-Storms, Jensen-Shannon, Euclidean et al. [Optional, default Default]
		-h Or --help. Show this help message and exit

## PM_Marker_Test.R: selects bio-markers by OTU table and discrete metadata

Used for bio-marker detection based on discrete variables. PM_Marker_ Test.R accepts the results of PM-select-taxa and PM-select-func. (see Abundance_Tables)

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Marker_Test.R [Option] Value
	
	[Options]
		-i ABUND_FILE, --abund_file=ABUND_FILE
			Input feature table with relative abundance (*.Abd) [Required] (See Abundance table)
		-m META_DATA, --meta_data=META_DATA (See Meta-data format)
			Input meta-data file [Required].
		-o OUT_DIR, --out_dir=OUT_DIR
			Output path [default Marker]
		-p PREFIX, --prefix=PREFIX
			Output file prefix [Optional, default Out]
		-P PAIRED, --Paired=PAIRED
			(upper) If paired samples [Optional, default FALSE]
		-t THRESHOLD, --threshold=THRESHOLD
			Threshold of significance [Optional, default 0.01]
		-h Or --help. Show this help message and exit

## PM_Marker_Corr.R: calculates correlation between bio-markers and numerical meta-data

Used for bio-marker detection based on continuous variables. PM_Marker_ Corr.R accepts the results of PM-select-taxa and PM-select-func.(see Abundance_Tables)

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Marker_Corr.R [Option] Value
	
	[Options]
		-i TABLE_FILE, --table_file=TABLE_FILE
			Input feature table with relative abundance (*.Abd) [Required]. (See Abundance table)
		-m META_DATA, --meta_data=META_DATA (See Meta-data format)
			Input meta-data file [Required].
		-o OUT_DIR, --out_dir=OUT_DIR
			Output file path [default Corr_features]
		-p PREFIX, --prefix=PREFIX
			Output file prefix [default Out]
		-t P_CUTOFF, --p_cutoff=P_CUTOFF
			The cutoff of adjusted P values [default 0.1]
		-r R_CUTOFF, --r_cutoff=R_CUTOFF
			The cutoff of correlation coefficients [Optional, default 0.4]
		-h Or --help. Show this help message and exit

## PM_Marker_RFscore.R: calculated importance of bio-markers by OTU table

Used for bio-marker scoring with discrete variables based on Random Forest algorithm. PM_Marker_ RFscore.R accepts the output results of PM-select-taxa and PM-select-func. (see Abundance_Tables)

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Marker_RFscore.R [Option] Value

	[Options]
		-i TABLE_FILE, --table_file=TABLE_FILE
			Input feature table with relative abundance (*.Abd) [Required] (See Abundance table)
		-m META_DATA, --meta_data=META_DATA (See Meta-data format)
			Input meta-data file [Required].
		-o OUT_DIR, --out_dir=OUT_DIR
			Output file name[default RFimportance]
		-p PREFIX, --prefix=PREFIX
			Output file prefix  [Optional, default Out]
		-n NTREE, --ntree=NTREE
			Ntree for Random Forest [Optional, default 5000]
		-h Or --help. Show this help message and exit

## PM_Network.R: calculates the co-occurrence among OTUs by OTU table

For network based co-occurrence analysis. The output is in pdf format. This function has also been integrated in PM-comp-corr by parameter “-N”.

PM_Network.R accepts the results of PM-comp-corr, PM-comp-taxa and PMcomp-func.

**Usage:**

	Rscript $ParallelMETA/Rscript/PM_Network.R [Option] Value

	[Options]
		-i DIST_FILE, --dist_file=DIST_FILE
			Input distance matrix [Required]
		-o OUTFILE, --outfile=OUTFILE
			Output Network [default network.pdf]
		-p POSITIVE_EDGES, --positive_edges=POSITIVE_EDGES
			If enable the positive edges [Optional, default TRUE]
		-n NEGATIVE_EDGES, --negative_edges=NEGATIVE_EDGES
			If enable the negative edges [Optional, default TRUE]
		-t THRESHOLD, --threshold=THRESHOLD
			Edge threshold [Optional, default 0.7]
		-h Or --help. Show this help message and exit

# Formats

## Sequence format and sequence list

Usually Parallel-META 3 accepts split sequences that each sample is in one single Fasta/Fastq file. For Fasta/Fastq format, sample ID should not contain space symbol (‘ ‘) and table symbol (‘\t’), and each sequence is in 1 single line. For 16S rRNA sequences, Parallel-META 3 support pair-ended sequences (-R), and for metagenomic shotgun sequences Parallel-META 3 only support single-ended sequences

For PM-pipeline, input path of all input samples (pairs) should be contained in the sequence list. In the sequence list:

**Single-ended sequences:** each sample has one single line for one Fasta/Fastaq file, such as:

	/home/data/sample1.fasta
	/home/data/sample2.fasta
	/home/data/sample3.fasta

**Pair-ended sequences:** each sample has two lines for pair-1 sequences and pair-2 sequences in Fasta/Fastq format, such as:

	/home/data/sample1_pair1.fasta
	/home/data/sample1_pair2.fasta
	/home/data/sample2_pair1.fasta
	/home/data/sample2_pair2.fasta
	/home/data/sample3_pair1.fasta
	/home/data/sample3_pair2.fasta
	/home/data/sample4_pair1.fasta
	/home/data/sample4_pair2.fasta

**Integrated sequences:** In addition, Parallel-META 3 also supports integrated Fasta/Fastq with barcode or group information (Mothur format) or in QIIME format. The integrated sequences should be split by PM-split-seq before the analysis starts, and PM-split-seq can also automatically make the sequence list for all samples.

The barcode file format:

	ATTCGT Sample1
	AGCGTC Sample2
	……
	CGTGAC SampleN

The group file format:

	Seq_Id_1 Sample1
	Seq_Id_2 Sample2
	……
	Seq_Id_N SampleN

## Meta-data format (usually for –m)

In the meta-data file, each row represents one sample and each column represents one feature. Input samples should have the same order in meta-data file and sample list file. Sample IDs should not be started with number and symbol ‘#’, and should not contain space symbol (‘ ’), backslash symbol (‘/’) and table symbol (‘\t’).

Example:

	SampleID	Habitat		Sex	Host
	Sample1		Palm		M	H1
	Sample2		Oral		F	H2
	Sample3		Gut		M	H1
	Sample4		Gut		F	H3

## Single sample profile list format (usually for –l)

In the single sample profile list, each row represents one sample, with sample ID and path to its profiling result by PM-parallel-meta.

Example:

	Sample1	/home/data/results1/classification.txt
	Sample2	/home/data/results2/classification.txt
	Sample3	/home/data/results3/classification.txt

The path could be either absolute path or relative path. For relative path, the prefix can be assigned by parameter –p.

## Abundance table (OTU table) format (usually for –T)

In the abundance table, each row represents one sample, and each column represents the absolute sequence count (*.Count) or the relative abundance (*.Abd) of a sample on one community feature (eg. OTU or taxa).

Example:

	SampleID	OTU_1	OTU_2	OTU_3
	Sample1		3	9	0
	Sample2		5	10	0
	Sample3		6	5	0
	Sample4		0	2	8

The OTU table can be generated by PM-select-taxa from the profiling results of PM-parallel-meta:

	PM-select-taxa –l list.txt –o taxa.txt –L 7

and the output taxa.OTU.Count is the OTU table with sequence count information. By OTU table, abundance tables on other taxonomy levels can be generated by PM-select-taxa (eg. Genus level):

	PM-select-taxa –T taxa.OTU.Count –o taxa.txt –L 6

# Results

After using PM-pipeline, you might get the following folders/files in the output directory. In each directory, files/tables/figures are named with prefix “taxa” are taxonomy results, as well as “func” are metabolic functional results. From 3.5.3 PM-pipeline provides an index page for results browsing.

## index.html (web page)

This is the index page to browse for results browsing. Users can open it by a webpage browser and view the detailed results by hyperlink s. Please notice that

a. the “index.html” only works in the output directory;

b. JavaScript, SVG, HTML5 and PDF should be supported by the browser;

c. Links may not available with customized parameters. See "More results" for all available results.

## Sample_Views (dir)

This directory contains the visualized sample view (taxonomy.html, JavaScript, SVG and HTML5 should be supported) in interactive pie charts across multiple samples.

## Abundance_Tables (dir)

This directory contains the relative abundance tables (*.Abd), absolute sequence count tables (*.Count), and bar charts (*Abd.pdf) of multiple samples on different taxonomical and functional levels.

## Distance_Matrix (dir)

This directory contains the pair-wised distance matrix (*.dist) of all input samples and unsupervised clustering results (*.dist.clusters.pdf and *.dist.heatmap.pdf) based on OTUs and KO profiles of multiple samples. Distances are computed based on Metastorms algorithm [Su, et al., Bioinformatics, 2012].

## Clustering (dir)

This directory contains the supervised clustering results based on PCA (*.pca.pdf) and PCoA (*.pcoa.pdf).

## Alpha_Diversity (dir)

This directory contains the multivariate statistical analysis results (*.Alpha_diversity_Boxplot.pdf and *.Alpha_diversity_Index.txt) and rarefaction curve (refer to section 5.6 for details) of alpha diversity. P-values are estimated by rank-sum tests.

## Beta_Diversity (dir)

This directory contains the multivariate statistical analysis results (*.Beta_diversity_Boxplot.pdf and *.taxa.dist.Beta_diversity_Values.txt) of beta diversity. P-values are estimated by Adonis/Permanova tests.

## Markers (dir)

This directory contains the biomarker organisms (*.sig.boxplot.pdf and *.sig.meanTests.xls) and their Random Forest scores (*.RFimportance.pdf and *. RFimportance.txt) among different groups.

## Network (dir)

This directory contains the microbial interaction network (*.network.pdf) based on different taxonomical and functional levels.

## Single_Sample (dir)

In this directory, each sub folder is the detailed information of an individual sample named by the sample ID. In the sub directories there may be

a. classification.txt (plain-text file): The OTUs and taxonomy information of this sample (new version, compatible with 3.4.2 or later).

b. classification_detail.txt (plain-text file): The detailed sequence mapping, OTUs and taxonomy information of this sample (compatible with 3.4.1 or lower).

c. functions.txt (plain-text file): The predicted KO function information of this sample.

d. taxonomy.html (HTML webpage): The visualized sample view in interactive pie chart of this sample.

e. meta.rna (fasta sequences): The extracted 16S/18S rRNA fragment, if the input is metageomic shotgun sequences (see PM-pipeline).

f. Analysis_Report.txt (plain-text file): The analysis report including parameters configuration and analysis information statistics.

## Single_Sample.List (dir)

This directory contains the profiling results path list (named as taxa.list, see Single sample profile list) of all samples. Each list has 2 columns: the first column is the samples’ ID and the second column is the path of the profiling result.

## Logs (plain-text file)

a. Analysis_Report.txt: The analysis report including parameters configuration and analysis information statistics.


## Network (dir)

This directory contains the microbial interaction network (*.network.pdf) based on different taxonomical and functional levels.

## Single_Sample (dir)

In this directory, each sub folder is the detailed information of an individual sample named by the sample ID. In the sub directories there may be

a. classification.txt (plain-text file): The OTUs and taxonomy information of this sample (new version, compatible with 3.4.2 or later).

b. classification_detail.txt (plain-text file): The detailed sequence mapping, OTUs and taxonomy information of this sample (compatible with 3.4.1 or lower).

c. functions.txt (plain-text file): The predicted KO function information of this sample.

d. taxonomy.html (HTML webpage): The visualized sample view in interactive pie chart of this sample.

e. meta.rna (fasta sequences): The extracted 16S/18S rRNA fragment, if the input is metageomic shotgun sequences (see PM-pipeline).

f. Analysis_Report.txt (plain-text file): The analysis report including parameters configuration and analysis information statistics.

## Single_Sample.List (dir)

This directory contains the profiling results path list (named as taxa.list, see Single sample profile list) of all samples. Each list has 2 columns: the first column is the samples’ ID and the second column is the path of the profiling result.

## Logs (plain-text file)

a. Analysis_Report.txt: The analysis report including parameters configuration and analysis information statistics.

b. scripts.sh: The detailed scripts of each analysis step.

c. error.log: The warning and error messages.

# Contact

Any problem please contact Parallel-META development team

	Mr. JING Gongchao	E-mail: jinggc@qibebt.ac.cn
