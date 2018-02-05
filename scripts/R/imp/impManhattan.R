rm(list=ls())

args = (commandArgs(TRUE))

info = read.table(paste0("/group/research/mvp001/snakemake/info/imputed.", args[4], ".info"), T, stringsAsFactors = F)
info$SNP = paste0("chr", info$SNP)
info = unlist(info)

##=============================
### data handling
###=============================
source('/group/research/mvp001/snakemake/scripts/R/imp/qqman.R')
in.data <- read.table(file = args[1], header = T, sep = " ", stringsAsFactors = FALSE)

# other names if metal or snptest or plink
names(in.data) = c("SNP", "CHR", "BP", "NEA", "EA", "N", "EAF", "BETA", "SE", "P")

### handle zero pvalue
in.data$P = as.numeric(in.data$P)
in.data[which(in.data$P == 0), "P"] <- NA #min(in.data[which(in.data$P > 0), "P"])
in.data[which(in.data$P >= 1), "P"] <- NA
in.data[which(in.data$P < 0),  "P"] <- NA
in.data = in.data[in.data$CHR %in% c(1:22),]
in.data = in.data[which(is.na(in.data$P) == F),]
in.data = in.data[order(in.data$CHR, in.data$BP),]
in.data = in.data[which(in.data$SNP %in% info),]

# args[5] = "summary/imp/NAFLDadj/NAFLDadj.EUR.imp.info0.6.maf0.01.score.out"
#write.table(in.data, args[5], row.names = F, col.names = T, quote = F, sep = " ")

### remove the observations with non-valid p-values and not duplicated chrcbp
in.data <- in.data[!duplicated(in.data[,"SNP"]) & !is.na(in.data[,"P"]),]

write.table(in.data, args[5], row.names = F, col.names = T, quote = F, sep = " ")


# color the genome wide significant snps
highlight = unlist(in.data[which(in.data$P < 0.00000005),"SNP"])

png(file = args[2], width = 1000, height = 700)
manhattan(in.data, cex = 0.6, highlight = highlight)
dev.off()

in.data$stats <- qchisq(1 - in.data$P, 1)
LAMBDA <- median(in.data$stats) / 0.4549
print(LAMBDA)
lambdatext <- LAMBDA

### QQ plot
qqdata 	= in.data
obs 	= -log10(sort(qqdata$P))
exp	= -log10(1:length(obs) / length(obs))
maxxy	= max(max(obs), max(exp))
	
png(file = args[3])
plot(x = exp, 
	y = obs, 
	pch = 20, 
	xlim = c(0, maxxy + 1), 
	ylim = c(0, maxxy + 1),
	xlab = "Expected -lg(p-value)", 
	ylab = "Observed -lg(p-value)", 
	sub = lambdatext
)
segments(x0 = 0, 
	y0 = 0, 
	x1 = maxxy, 
	y1 = maxxy, 
	lwd = 2, 
	col = "blue"
)
dev.off()

