# Manhattan Plotter
Plot genome-wide association study analysis summary statsitics, label genes at hits of interest and in general try to make some pretty pictures.

#### This is a repository to help make plots similar to Figure 2 in https://www.biorxiv.org/content/10.1101/388165v3 

## Plots generated look like this ...
![Parkinson's disease meta-GWAS from bioarxiv](https://github.com/ipdgc/Manhattan-Plotter/blob/master/parkinsonManhattan.png)
...but maybe with less skyscrapers (maybe more, who knows?).

## Script usage is below

#### To run the script:
```
Rscript manhattanPlotter.R [gwas] [hits] [output]
```

#### Options include:
```
[gwas] <-- a file containing GWAS summary statistics. Mandatory columns to include are SNP, CHR, BP and P.
```
In this file SNP is a unique text identifier for the variant of interest, CHR is the chromosome number, BP is the base pair position and P is the p-value for the SNP parameter.
```
[hits] <-- a file containing annotation for GWAS hits of interest. Mandatory columns to include are SNP, STATUS and GENE.
```
In this file, SNPs of interest are listed with a STATUS indicator (binary) and a GENE label (character strings).
```
[output]<-- a character string with no spaces, whatever you want to name this plot.
```
Pretty straightforward.

## Example input files

GWAS file
```
```

Hits file
```
```

## Depends on
R > 3.5 with packages data.table, tidyverse, ggrepel and reshape2

### Questions or comments
[Mike Nalls](mike@datatecnica.com)
