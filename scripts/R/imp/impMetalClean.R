rm(list=ls())

args = commandArgs(trailingOnly = T)

file.in  = args[1]
file.all = args[2]
file.sig = args[3]
file.tab = args[4] 

# import
d <- read.table(file = file.in, header = T, as.is = T, sep = "\t", stringsAsFactors = F)

# INSERT CHR AND BP
colnames(d)[1]  = "CHRCBP"
colnames(d)[16] = "N_INFORMATIVE"
colnames(d)[8]  = "EFFECT"
colnames(d)[10] = "PVALUE"
d$EA            = toupper(d$Allele1)
d$NEA           = toupper(d$Allele2)
colnames(d)[4]  = "EAF"
colnames(d)[9]  = "SE"

# remove everything after : (CHR) or everything before : (BP)
d$CHR = gsub(pattern = "(:).*", replacement = "", x = d$CHRCBP)
d$CHR = gsub(pattern = "chr", replacement = "", x = d$CHR)
d$POS = gsub(pattern = ".*(:)", replacement = "", x = d$CHRCBP)

# order
d = d[order(d$CHR, d$POS), ]

# filter
d.sig = subset(d, d$PVALUE < 5e-08)
# d.tab = subset(d, d$PVALUE < 5e-8)

# prettify
d <- d[, c("CHRCBP", "CHR", "POS", "EA", "NEA", "EAF",  "EFFECT", "SE", "PVALUE", "N_INFORMATIVE")]

# export
write.table(d, file = file.all, col.names = T, row.names = F, quote = F, sep = "\t")
write.table(d.sig, file = file.sig, col.names = T, row.names = F, quote = F, sep = "\t")
# write.table(d.tab, file = file.tab, col.names = T, row.names = F, quote = F, sep = "\t")
