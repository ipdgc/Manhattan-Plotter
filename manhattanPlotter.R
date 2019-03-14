## command line usage
### Rscript manhattanPlotter.R [gwas] [hits] [output]
### [gwas] <-- a file containing GWAS summary statistics. Mandatory columns to include are SNP, CHR, BP and P.
### [hits] <-- a file containing annotation for GWAS hits of interest. Mandatory columns to include are SNP, STATUS and GENE.
### [output]<-- a character string with no spaces, whatever you want to name this plot.

## command line example for testing
### Rscript manhattanPlotter.R testGwas.tab testHits.tab testPlot
# gwasFile <- "testGwas.tab"
# hitsFile <- "testHits.tab"
# output <- "testPlot"

## arguments from command lines

args <- commandArgs()
print(args)
gwasFile <- args[6] # gwas file
hitsFile <- args[7] # hits file
output <- args[8] # results prefix

## set up the environment and load packages

library("data.table")
library("tidyverse")
library("reshape2")
library("ggrepel")

## load data for plotting

gwas <- fread(file = gwasFile, header = T)
hits <- fread(file = hitsFile, header = T)

## munge GWAS summary stats, also factor code the p-values as per Pulit et al., 2016
### we also truncate P values at -log10P of 40 to keep the Y axis looking good

gwas$log10Praw <- -1*log(gwas$P, base = 10)
gwas$log10P <- ifelse(gwas$log10Praw > 40, 40, gwas$log10Praw)
gwas$Plevel <- NA
gwas$Plevel[gwas$P < 5E-08] <- "possible"
gwas$Plevel[gwas$P < 5E-09] <- "likely"

## reduce gwas object for more efficient plotting
### this drops everything not useful in future AUC calcs estiamte in Nalls et al., 2019

gwasFiltered <- subset(gwas, log10P > 3.114074) 

## note hits to annotate

snpsOfInterest <- hits$SNP

## now merge the filtered GWAS plus annotation

gwasToPlotUnsorted <- merge(gwasFiltered, hits, by = "SNP", all.x = T)
gwasToPlot <- gwasToPlotUnsorted[order(gwasToPlotUnsorted$CHR,gwasToPlotUnsorted$BP),]

### prep the dataset for plotting

plotting <- gwasToPlot %>% 
  
### chromsome spacing
  
group_by(CHR) %>% 
summarise(chr_len=max(BP)) %>% 
  
### calculate cumulative position of each chromosome

mutate(tot=cumsum(chr_len)-chr_len) %>%
select(-chr_len) %>%
  
### add this info to the initial dataset

left_join(gwasToPlot, ., by=c("CHR"="CHR")) %>%
  
### space the SNPs correctly

arrange(ordered(CHR), BP) %>%
mutate( BPcum=BP+tot) %>%
  
### highlight hits

mutate( is_highlight=ifelse(SNP %in% snpsOfInterest, "yes", "no")) %>%
mutate( is_annotate=ifelse(log10P>7.30103, "yes", "no")) 

### prepare X axis to accomodate all CHR sizes

axisdf <- plotting %>% group_by(CHR) %>% summarize(center=( max(BPcum) + min(BPcum) ) / 2 )

### make the plot panel

thisManhattan <- ggplot(plotting, aes(x=BPcum, y=log10P)) +
  
### show all points and color by CHR, a classy grey on grey
  
  geom_point( aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
  scale_color_manual(values = rep(c("light grey", "dark grey"), 22 )) +
  
### custom X axis that removes the spaces between X axis and SNPS
  
  scale_x_continuous( label = axisdf$CHR, breaks= axisdf$center ) +
  scale_y_continuous(expand = c(0, 0) ) +
  
### add highlighted points, these highlighted points are adding an estimate of confidence for "genome-wide significant hits"
### red = more likely to replicate than orange
### related to Pulit et al. 2016
  
  geom_point(data=subset(plotting, is_highlight=="yes" & Plevel == "likely"), color = "red", size=2) +
  geom_point(data=subset(plotting, is_highlight=="yes" & Plevel == "possible"), color = "orange", size=2) +
  
### add label using ggrepel to avoid overlapping, here the label color coding is STATUS from the hits file and the text is the GENE from that file
  
  geom_label_repel( data=subset(plotting, is_annotate=="yes"), aes(label=NominatedGene, fill=factor(Status)), alpha = 0.5,  size=2) +
  scale_fill_manual(values = c("aquamarine","cyan")) +

### last bit of theme mods

  theme_bw() +
  theme( 
    legend.position="none",
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  ) +
  xlab("BP") +
  ylab("-log10P")

## now export it

try(ggsave(plot = thisManhattan, file = paste(output, ".manhattanPlot.png", sep = ""), units = c("in"), dpi = 300, height = 5, width = 12))

## kill it and go

q("no")
