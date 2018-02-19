args = commandArgs(trailingOnly = T)

pval_cut        = 5e-8
half_window     = 500000       ### 500Kb, half window

file.in    <- args[1]
file.out   <- args[2]

d     = read.table(file = file.in, header = T, as.is = T, sep = "\t")
d$CHR = gsub(pattern = "(:).*", replacement = "", x = d$CHRCBP)
d$CHR = gsub(pattern = "chr", replacement = "", x = d$CHR)
d$POS = as.numeric(gsub(pattern = ".*(:)", replacement = "", x = d$CHRCBP))

comb    <- NULL
for (iCHR in 1:22) 
  {
  ### lead SNP candidates
  ds      <- d[d$CHR == iCHR & d$PVALUE < pval_cut, c("POS", "PVALUE")]
  if (nrow(ds) > 0) 
  {
    for (i in 1:nrow(ds)) 
    {
        current_pos     <- ds$POS[i]
        current_pval    <- ds$PVALUE[i]
        current_nbhd    <- ds[ds$POS >= current_pos - half_window & ds$POS <= current_pos + half_window,]
        most_sig_pval   <- min(current_nbhd$PVALUE)
        refsnp_pos      <- current_nbhd$POS[current_nbhd$PVALUE == most_sig_pval]
        refsnp_chrcbp   <- paste0("chr", iCHR, ":", refsnp_pos)
        df      <- data.frame(chr = iCHR, pos = refsnp_pos, chrcbp = refsnp_chrcbp, pval = most_sig_pval)
        comb    <- rbind(comb, df)
    }
  }
}

comb    <- comb[!duplicated(comb), ]
write.table(comb, file = file.out, col.names = T, row.names = F, quote = F, sep = "\t")
