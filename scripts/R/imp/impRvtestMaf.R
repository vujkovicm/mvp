args = commandArgs(trailingOnly = T)

maf = args[1]
file.in = args[2]
file.out = args[3]

df = read.table(file.in, sep = " ", T, stringsAsFactors = F, fill = T)

df.maf = df[which(df$AF > maf), ]

df.maf$CHRCBP = paste(df.maf$CHROM, ":", df.maf$POS, sep = "")
df.maf$filename = NULL

write.table(df.maf, file.out, sep = " ", col.names = T, row.names = F, quote = F)
