rm(list=ls())

args = commandArgs(trailingOnly = T)

file.in  = args[1]
file.all = args[2]
file.sig = args[3]
file.tab = args[4] 

# import
d <- read.table(file = file.in, header = T, as.is = T, sep = " ", stringsAsFactors = F)
colnames(d)[1] = "CHRCBP"
colnames(d)[3] = "POS"
colnames(d)[6] = "N_INFORMATIVE"
colnames(d)[8] = "EFFECT"
colnames(d)[10] = "PVALUE"

d.all = d[, c("CHRCBP", "PVALUE")]
d.sig = subset(d.all, d.all$PVALUE < 5e-08)
d = d[order(d$CHR, d$POS), ]
d <- d[, c("CHRCBP", "EA", "NEA", "EAF",  "EFFECT", "SE", "PVALUE", "N_INFORMATIVE")]
d.tab = subset(d, d$PVALUE < 5e-8)

# export
write.table(d.all, file = file.all, col.names = T, row.names = F, quote = F, sep = "\t")
write.table(d.sig, file = file.sig, col.names = T, row.names = F, quote = F, sep = "\t")
write.table(d.tab, file = file.tab, col.names = T, row.names = F, quote = F, sep = "\t")

