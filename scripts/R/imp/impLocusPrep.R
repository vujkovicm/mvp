args = commandArgs(trailingOnly = T)

pval_cut        <- 5e-8
half_window     <- 500000       ### 500Kb, half window

file.in    <- args[1]
file.out   <- args[2]

d       <- read.table(file = file.in, header = T, as.is = T, sep = "\t")

### provide the chromosome and position information
pos     <- regexpr(":", d$CHRCBP, fixed=TRUE)
d$chr   <- as.numeric(substr(d$CHRCBP, 4, pos - 1))
d$pos   <- as.numeric(substr(d$CHRCBP, pos + 1, nchar(d$CHRCBP)))
combo   <- NULL
for (iCHR in 1:22) 
  {
  ### lead SNP candidates
  ds      <- d[d$chr == iCHR & d$PVALUE < pval_cut, c("pos", "PVALUE")]
  if (nrow(ds) > 0) 
  {
    for (i in 1:nrow(ds)) 
    {
        current_pos     <- ds$pos[i]
        current_pval    <- ds$PVALUE[i]
        current_nbhd    <- ds[ds$pos >= current_pos - half_window & ds$pos <= current_pos + half_window,]
        most_sig_pval   <- min(current_nbhd$PVALUE)
        refsnp_pos      <- current_nbhd$pos[current_nbhd$PVALUE == most_sig_pval]
        refsnp_chrcbp   <- paste0("chr", iCHR, ":", refsnp_pos)
        df      <- data.frame(chr = iCHR, pos = refsnp_pos, chrcbp = refsnp_chrcbp, pval = most_sig_pval)
        combo   <- rbind(combo, df)
    } ### i
  }
} ### iCHR
combo    <- comb[!duplicated(combo), ]
write.table(combo, file = file.out, col.names = T, row.names = F, quote = F, sep = "\t")
