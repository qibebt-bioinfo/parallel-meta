# Parallel-Meta 3.5

![Version](https://img.shields.io/badge/Version-3.5-brightgreen.svg)
![Release date](https://img.shields.io/badge/Release%20date-Feb.%201%2C%202019-brightgreen.svg)



## Contents

- [Introduction](#introduction)
- [System Requirement and dependency](#system-requirement-and-dependency)
- [Installation guide](#installation-guide)
- [Supplementary](#supplementary)

# Introduction

Parallel-META 3 is a comprehensive and full-automatic computational toolkit for rapid data mining among microbiome datasets, with advanced features including sequence profiling and OTU picking, rRNA copy number calibration, functional prediction, diversity statistics, bio-marker selection, interaction network construction, vector-graph-based visualization and parallel computing. Both metagenomic shotgun sequences and 16S/18S rRNA amplicon sequences are accepted.

# System Requirement and dependency

## Hardware Requirements

Parallel-META 3 only requires a standard computer with sufficient RAM to support the operations defined by a user. For typical users, this would be a computer with about 2 GB of RAM. For optimal performance, we recommend a computer with the following specs:

  RAM: 8+ GB  
  CPU: 4+ cores, 3.3+ GHz/core

## Software Requirements

OpenMP library is the C/C++ parallel computing library. Most Linux releases have OpenMP already been installed in the system. In Mac OS X, to install the compiler that supports OpenMP, we recommend using the Homebrew package manager:
```
brew install gcc --without-multilib
```

# Installation guide

## Automatic Installation (recommended)

At present, Meta-Storms 2 provides a fully automatic installer for easy installation.

a. Download the package:
```
git clone https://github.com/qibebt-bioinfo/meta-storms.git	
```

b. Install by installer:
```
cd meta-storms
source install.sh
```

The package should take less than 1 minute to install on a computer with the specifications recommended above.

The example dataset could be found at “example” folder. Check the “example/Readme” for details about the demo run.

## Manual Installation

If the automatic installer fails, Meta-Storms 2 can still be installed manually.

a. Download the package:
```
git clone https://github.com/qibebt-bioinfo/meta-storms.git	
```

b. Configure the environment variables (the default environment variable configuration file is “~/.bashrc”):
```
export MetaStorms=Path to Meta-Storms 2
export PATH=”$PATH:$MetaStorms/bin/”
source ~/.bashrc
```
c. Compile the source code:
```
cd meta-storms
make
```

# Supplementary

The test code and datasets for reproducing the results of manuscript "Model-free disease classification across cohorts via microbiome search" is available here ([Linux X86_64](http://bioinfo.single-cell.cn/Released_Software/meta-storms/test_package/test_package_linux.tar.gz) / [Mac OS X](http://bioinfo.single-cell.cn/Released_Software/meta-storms/test_package/test_package_mac.tar.gz), ~ 892 MB). See “Readme.txt” in the package for usage and details.
