rm(list=ls())

args = commandArgs(trailingOnly = T)

file.in  = args[1]
file.all = args[2]
file.sig = args[3]
file.tab = args[4] 

# import
d <- read.table(file = file.in, header = T, as.is = T, sep = "\t")

d.all = d[, c("MarkerName", "P.value")]
names(d.all) = c("CHRCBP", "PVALUE")

d.sig = subset(d.all, d.all$PVALUE < 5e-08)

dim(d); names(d)

# transform
pos  	<- regexpr(":", d$MarkerName, fixed = TRUE)
d$chr   <- as.numeric(substr(d$MarkerName, 4, pos - 1))
d$pos   <- as.numeric(substr(d$MarkerName, pos + 1, nchar(d$MarkerName)))
d       <- d[order(d$chr, d$pos), ]
d$EA    <- toupper(d$Allele1)
d$NEA   <- toupper(d$Allele2)

names(d)[names(d) == "MarkerName"]  <- "SNP"
names(d)[names(d) == "P.value"]     <- "P_value"
names(d)

d <- d[, c("SNP", "EA", "NEA", "Effect", "StdErr", "P_value", "Direction", "N_INFORMATIVE")]

d.tab = subset(d, d$P_value < 5e-8)

# export
write.table(d.all, file=file.all, col.names = T, row.names = F, quote = F, sep = "\t")
write.table(d.sig, file=file.sig, col.names = T, row.names = F, quote = F, sep = "\t")
write.table(d.tab, file=file.tab, col.names = T, row.names = F, quote = F, sep = "\t")

