args = commandArgs(trailingOnly = TRUE)
dir  = "/snakemake/"

# create metal script file
sink(file = args[1], append = T)

# add metal parameters
cat("SCHEME STDERR\n")
cat("CUSTOMVARIABLE N_INFORMATIVE\n")
cat("LABEL N_INFORMATIVE AS N_INFORMATIVE\n\n")
cat("MARKER CHRCBP\n")
cat("FREQ AF\n")
cat("ALLELE REF ALT\n")
cat("EFFECT EFFECT\n")
cat("PVALUE PVALUE\n")
cat("WEIGHTLABEL N_INFORMATIVE\n")
cat("STDERR SE\n\n")
cat("AVERAGEFREQ ON\n")
cat("MINMAXFREQ ON\n")
cat("COLUMNCOUNTING STRICT\n")
cat("GENOMICCONTROL ON\n")
cat("SEPERATOR WHITESPACE\n")

# meta-analysis files
cat(paste("PROCESS ", dir, args[2], "\n", sep = ""))
cat(paste("PROCESS ", dir, args[3], "\n", sep = ""))
cat(paste("PROCESS ", dir, args[4], "\n", sep = ""))
cat("\n")

# export output
cat(paste("OUTFILE ", dir, args[5], "\n", sep = ""))
cat("ANALYZE HETEROGENEITY\n")
cat("QUIT\n")

# close metal script file
sink()

