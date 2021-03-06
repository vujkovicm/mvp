rm(list=ls())
args = commandArgs(trailingOnly = TRUE)
# args = c("summary/chp/NAFLD/NAFLD.AMR.chp.maf0.01.rvtest.out", "summary/chp/NAFLD/NAFLD.AMR.chp.maf0.01.m.png", "summary/chp/NAFLD/NAFLD.AMR.chp.maf0.01.q.png")

substrRight = function(x, n){
 	substr(x, nchar(x) - n + 1, nchar(x))
}

# for output from rvtest.out or metal.out
if(substrRight(args[1], 10) == "rvtest.out" | substrRight(args[1], 9) == "metal.out")
{
	col.chrcbp.name <- "CHRCBP"
	col.pvalue.name <- "PVALUE"
	file.sep = " "
}
# for output from meta_1
if(substrRight(args[1], 10) == "meta_1.out")
{
        col.chrcbp.name <- "MarkerName"
        col.pvalue.name <- "P.value"
	file.sep = "\t"
}

###============================
### set the output path for manhattan and qq plots
###============================

### the output Manhattan plot path
out.manh.path <- args[2]

### the output qq plot path
out.qq.path <- args[3]

##=============================
### data handling
###=============================
in.data <- read.table(file = args[1], header = T, sep = file.sep, stringsAsFactors = FALSE)
#colnames(in.data)[1] = col.chrcbp.name
#colnames(in.data)[7] = col.pvalue.name

#dim(in.data)
#names(in.data)

### handle zero pvalue
in.data[in.data[, col.pvalue.name] == 0, col.pvalue.name] <- 1e-300
	
### remove the observations with non-valid p-values and not duplicated chrcbp
in.data <- in.data[!duplicated(in.data[,col.chrcbp.name]) & !is.na(in.data[,col.pvalue.name]) & in.data[,col.pvalue.name]>0,]

### provide the chromosome and position information
colon.pos <- regexpr(":", in.data[,col.chrcbp.name], fixed = TRUE)
in.data$chr <- as.numeric(substr(in.data[,col.chrcbp.name], 4, colon.pos - 1))
in.data$pos <- as.numeric(substr(in.data[,col.chrcbp.name], colon.pos + 1, nchar(in.data[,col.chrcbp.name])))

in.data <- in.data[in.data$chr %in% c(1:22),]
in.data <- in.data[order(in.data$chr, in.data$pos),]

###=============================
### Manhattan Plot
###=============================

chr.start <- tapply(as.numeric(in.data$pos), INDEX = factor(in.data$chr), min)
chr.start <- chr.start[as.character(c(1:22))]
chr.end   <- tapply(as.numeric(in.data$pos), INDEX = factor(in.data$chr), max)
chr.end   <- chr.end[as.character(c(1:22))]
chr.span  <- chr.end - chr.start

### the cumulative no. of SNPs of the genomes
cumchr <- cumsum(chr.span)

### figure out the starting position of the chromosomes
chr.plot.start <- c(0, cumchr[1:21] + 100)
names(chr.plot.start) <- as.character(c(1:22))
names(chr.start) <- as.character(c(1:22))

### merge the starting position of each of the chromosome with the data and calculate the actual position that should be used by the manhattan plot
in.data$chr.plot.start <- chr.plot.start[in.data$chr]
in.data$chr.real.start <- chr.start[in.data$chr]
in.data$act.pos <- as.numeric(in.data$pos) + as.numeric(in.data$chr.plot.start) - as.numeric(in.data$chr.real.start)

### set up the color for plots
color1 <- "#C4BFBF"
color2 <- "#A79E9E"   # for different chromosomes
color3 <- "#E32828"   # for snps with pvalue <= 5e-8
color4 <- "#2D58FF"   # for snps with pvalue <= 5e-6
in.data$plot.col <- color1
in.data[as.numeric(in.data$chr) %% 2 == 0, "plot.col"] <- color2
in.data[as.numeric(in.data[,col.pvalue.name]) <= 5e-6, "plot.col"] <- color4
in.data[as.numeric(in.data[,col.pvalue.name]) <= 5e-8, "plot.col"] <- color3

### set up the point size for plots
cex1 <- "0.5"   # for all snps
cex3 <- "0.7"   # for snps with pvalue <= 5e-8
cex4 <- "0.6"   # for snps with pvalue <= 5e-6
in.data$plot.cex <- cex1
in.data[as.numeric(in.data[,col.pvalue.name]) <= 5e-6, "plot.cex"] <- cex4
in.data[as.numeric(in.data[,col.pvalue.name]) <= 5e-8, "plot.cex"] <- cex3

### set up the pch for plots
pch1 <- "19"   # for all snps
pch3 <- "19"   # for snps with pvalue <= 5e-8
pch4 <- "19"   # for snps with pvalue <= 5e-6
in.data$plot.pch <- pch1
in.data[as.numeric(in.data[,col.pvalue.name]) <= 5e-6, "plot.pch"] <- pch4
in.data[as.numeric(in.data[,col.pvalue.name]) <= 5e-8, "plot.pch"] <- pch3

### the x and y coordinates used for plots
in.data$XX <- as.numeric(in.data$act.pos)
in.data$YY <- -log10(as.numeric(in.data[,col.pvalue.name]))
### sort the data according to the X coordinates
in.data <- in.data[order(in.data$XX),]

### the lables for the x axis
### the position of the tick marks
chr.max <- tapply(in.data$XX, INDEX = factor(in.data$chr), max)
chr.min <- tapply(in.data$XX, INDEX = factor(in.data$chr), min)
x.tick.at <- (chr.max + chr.min) / 2
x.tick.lab <- as.character(c(1:22))
x.tick.at <- x.tick.at[order(x.tick.at)]

y.offset <- 0.1
### the tick mark and lables for the y axis
y.tick.max <- ceiling(max(in.data$YY))
y.tick.scale <- 10 ^ floor(log10(floor(y.tick.max / 6)))
y.tick.interval1 <- 1 * y.tick.scale
y.tick.interval2 <- 2 * y.tick.scale
y.tick.interval3 <- 5 * y.tick.scale

y.tick.interval <- y.tick.interval3
if (floor(y.tick.max / y.tick.interval1) <= 13) 
{
	y.tick.interval <- y.tick.interval1
} 
if (floor(y.tick.max / y.tick.interval2) <= 13) 
{
	y.tick.interval <- y.tick.interval2
} 
#else 
#{
#	y.tick.interval <- y.tick.interval3
#}

if (y.tick.interval < 1) { y.tick.interval <- 1}
y.tick.lack <- y.tick.max %% y.tick.interval
y.tick.max <- y.tick.max + y.tick.interval - y.tick.lack
y.tick.lab <- seq(0, y.tick.max, y.tick.interval)
y.tick.at <- y.tick.lab + y.offset

### provide the Manhattan plot
png(file = out.manh.path, width = 1000, height = 700)
plot(x = in.data$XX, 
	y = in.data$YY + y.offset, 
	pch = as.numeric(in.data$plot.pch), 
	cex = as.numeric(in.data$plot.cex), 
	col = in.data$plot.col, 
	axes = FALSE,
     	xlab = "", 
	ylab = "",
	ylim = c(-y.offset, y.tick.max + y.offset + 1)
)
text(x = x.tick.at, 
	y = y.offset, 
	pos = 1, 
	labels = x.tick.lab, 
	cex = 0.7
)
mtext("Genome", 
	side = 1, 
	line = 0
)
axis(2, 
	at = y.tick.at, 
	labels = y.tick.lab, 
	las = 1
)
mtext(expression(-log[10] ~ italic(P)), 
	side = 2, 
	line = 2.5
)		
#	abline(h=-log10(manh.p.cut)+y.offset, col="red", lty=2)
#	mtext(title.manhqq, side=3, line=2, cex=1.5)  
dev.off()

### use the pvalue approach to calculate the genomics inflation factor
### calculate the genomic inflation factor
in.data$stats <- qchisq(1 - in.data[,col.pvalue.name], 1)
LAMBDA <- median(in.data$stats) / 0.4549
print(LAMBDA)
lambdatext <- LAMBDA

### QQ plot
qqdata 	= in.data
obs 	= -log10(sort(qqdata[,col.pvalue.name]))
exp	= -log10(1:length(obs) / length(obs))
maxxy	= max(max(obs), max(exp))
	
png(file = out.qq.path)
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

