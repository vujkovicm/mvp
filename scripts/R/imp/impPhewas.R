args = (commandArgs(TRUE))

library(PheWAS)
library('yaml')

### configuration file
yml = yaml.load_file('config/imp-assoc.yaml')

### PheCODE
p = readRDS(file= "pheno/ICD9.clean.rds")

### additive genotype
g = read.table(file = paste0("summary/imp/", args[1], "/", args[2], "/", args[2], "_", args[3], ".raw"), header = T, as.is = T)
g = g[ , c(1,7:ncol(g))]
names(g)[names(g) == "FID"] = "mvp001_id"

### covariate file
cov = read.table(file = paste0("out/imp/", args[1], "/", args[1], ".", args[3], ".phe"), header=T, as.is=T)
names(cov)[names(cov) == "fid"] = "mvp001_id"
cov$iid = cov$fatid = cov$matid = cov$sex_core = NULL
# remove phenotype from covariate file (duhh)
cov[,args[1]] == NULL

### do PheWAS	
results	= phewas(phenotypes = p, genotypes = g, covariates = cov)

# split by SNP
split = split(results, f = results$snp)

# loop through split list
for (i in 1:length(split))
{
	snp = split[[i]][[2]][[1]]
	plot = phewasManhattan(split[[i]])
	png(paste("summary/imp/", args[1], "/", args[2], "/phewas/", args[3], ".", snp ,"_phewas.png", sep = ""), width = 1500, height = 800, units = "px")
	suppressWarnings(print(plot))
	dev.off()
	write.table(split[[i]], paste("summary/imp/", args[1], "/", args[2], "/phewas/", args[3], ".", snp, "_phewas.tab", sep = ""), row.names = F, col.names = T, quote = F, sep = "\t")
}
