# Parallel-META 3.5

![Version](https://img.shields.io/badge/Version-3.5-brightgreen.svg)
![Release date](https://img.shields.io/badge/Release%20date-Feb.%201%2C%202019-brightgreen.svg)



## Contents

- [Introduction](#introduction)
- [System Requirement and dependency](#system-requirement-and-dependency)
- [Download](#download)
- [Installation guide](#installation-guide)

# Introduction

Parallel-META 3 is a comprehensive and full-automatic computational toolkit for rapid data mining among microbiome datasets, with advanced features including sequence profiling and OTU picking, rRNA copy number calibration, functional prediction, diversity statistics, bio-marker selection, interaction network construction, vector-graph-based visualization and parallel computing. Both metagenomic shotgun sequences and 16S/18S rRNA amplicon sequences are accepted.

# System Requirement and dependency

## Hardware Requirements

Parallel-META 3 only requires a standard computer with sufficient RAM to support the operations defined by a user. For typical users, this would be a computer with about 2 GB of RAM. For optimal performance, we recommend a computer with the following specs:

  RAM: 8+ GB  
  CPU: 4+ cores, 3.3+ GHz/core

## Software Requirements

### Rscript environment:

For statistical analysis and pdf format output, Parallel-META 3 requires cran R (http://cran.r-project.org/) 3.0 or higher for the execution of “.R” scripts. Then all packages could be automatically installed and updated by the Parallel-META 3 installer.

### Bowtie2 (2.1.0 or higher, included in the package):

Bowtie2 has been integrated in the package. If you want to install/update manually, please download from http://sourceforge.net/projects/bowtie-bio/files/bowtie2/ and put the “bowtie-align-s”to $ParallelMETA/Aligner/bin/.

### HMMER 3 (3.0 or higher, included in the package):

HMMER3 has been integrated in the package. If you want to install/update manually, please download from
http://hmmer.janelia.org/software/ and put the “hmmsearch” to $ParallelMETA/HMMER/bin/.

### Compiler (only required by source code package):
g++ 4.0 or higher for Linux / g++-6 6.0 or higher for Mac OS X.

# Download

The latest release is available at:
http://bioinfo.single-cell.cn/parallel-meta.html

# Installation guide

## Automatic Installation (recommended)

Now the Parallel-META provides a fully automatic installer for easy installation.

a. Extract the package:

```
tar –xzvf parallel-meta-3.tar.gz
```

b. Install

```
cd parallel-meta
source install.sh
```

The package should take less than 1 minute to install on a computer with the specifications recommended above.

The example dataset could be found at “example” folder. Check the “example/Readme” for details about the demo run.

## Manual Installation

If the automatic installer failed, Parallel-META 3 can still be installed manually.

a. Extract the package:

```
tar –xzvf parallel-meta-3.tar.gz
```

b. Configure the environment variables (default environment variable configuration file is located at “~/.bashrc” or “~/.bash_profile”)

```
export ParallelMETA=Path to Parallel-META 3
export PATH=”$PATH:$ParallelMETA/bin”
source ~/.bashrc
```

c. Install R packages

```
Rscript $ParallelMETA/Rscript/config.R
```

d. Compile the source code* (only required by the source code package):

```
cd parallel-meta
make
```
