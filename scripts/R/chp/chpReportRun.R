args <- commandArgs(trailingOnly = TRUE)

setwd("/group/research/mvp001/snakemake/")

# getting pandoc errors with executing html reports
# conda install -c conda-forge pandoc=1.19.2

library(rmarkdown)
library(markdown)
library(tools)
library(knitr)

knit("scripts/R/report.Rmd")

html_file=paste("summary/chp/", args[1], "/", args[1], ".", args[2], ".chp.maf", args[3], ".html", sep = "")
pdf_file=paste("summary/chp/", args[1], "/", args[1], ".", args[2], ".chp.maf", args[3], ".pdf", sep = "")
pandoc=paste("pandoc -s ", html_file,  " -o ", pdf_file)

render("scripts/R/chpReport.Rmd",  html_file)
#system(pandoc)

#rmarkdown::render(input = "scripts/R/chpReport.Rmd", output_file = paste("../../summary/chp/", args[1], "/", args[1], ".", args[2], ".chp.maf", args[3], ".pdf", sep = ""))
