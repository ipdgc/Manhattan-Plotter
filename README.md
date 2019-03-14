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
SNP	CHR	BP	P
chr1:60320992	1	60320992	0.38
chr8:135908647	8	135908647	0.66
chr11:97895884	11	97895884	0.31
chr18:814730	18	814730	0.91
chr10:120407145	10	120407145	0.12
chr11:29372878	11	29372878	0.82
chr3:164053059	3	164053059	0.21
chr20:14479321	20	14479321	0.20
chr2:220200263	2	220200263	0.31
...
```

Hits file
```
SNP	STATUS	GENE
chr1:154898185	0	PMVK
chr1:155135036	0	KRTCAP2
chr1:155205634	0	GBAP1
chr1:161469054	1	FCGR2A
chr1:171719769	1	VAMP4
chr1:205723572	0	NUCKS1
chr1:205737739	0	RAB29
chr1:226916078	0	ITPKB
chr1:232664611	0	SIPA1L2
...
```

Command
```
Rscript manhattanPlotter.R testGwas.tab testHits.tab testPlot
```

## Depends on
R > 3.5 with packages data.table, tidyverse, ggrepel and reshape2

## Questions or comments
[Mike Nalls](mike@datatecnica.com)
