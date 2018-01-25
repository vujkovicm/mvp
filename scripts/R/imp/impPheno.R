rm(list=ls())
args = commandArgs(trailingOnly = TRUE)

# test
# args = c("pheno/T2D_datacube.modified.csv", "pop/MVP001.AFR.pca")

library('yaml')

yml = yaml.load_file('config/imp-assoc.yaml')

### PHENO + PCA 
cube  	= read.table(args[1], header = T, as.is = T, sep = " ")
pca 	= read.table(args[2], header = T, stringsAsFactors = F, sep = " ")

### MERGE  
phe 	 = merge(cube, pca, by.x = "mvp001_id", by.y = "mvp001_id", all.x = T)

### PED
ped 	= phe[, c("mvp001_id", "mvp001_id", "mvp001_id", "mvp001_id", "female")]
names(ped) = c("fid", "iid", "fatid", "matid", "sex_core")
ped$fatid = 0
ped$matid = 0
ped$sex_core = 0
for(i in 1:length(yml$impCOV))
{
	ped = cbind.data.frame(ped, phe[, yml$impCOV[[i]][[1]][1]])
	colnames(ped)[i + 5] = names(yml$impCOV)[i]
	# ped[, i + 5] = 0
	# now fill out a little better 
	if(length(yml$impCOV[[i]]) == 3)
	{
		# category to numeric
		if(yml$impCOV[[i]][2] %in% c('B', 'D'))
		{
			tmp <- ped[, i + 5]
                        tmp <- ifelse(ped[,i + 5]  == yml$impCOV[[i]][3], '1', ifelse(ped[,i + 5] == "", NA, '2'))
                        ped[,i + 5] <- tmp
		}
		else if(yml$impCOV[[i]][2] %in% c('P', 'C'))
                {
                        if(yml$impCOV[[i]][3] == 'int')
                        {
                                ped[, i + 5] <- ifelse(is.na(as.numeric(ped[, i + 5])), NA, qnorm((rank(as.numeric(ped[, i + 5])) - 3/8) / (nrow(ped) + 1/4)))
                        }
                        else if (yml$impCOV[[i]][3] == 'log')
                        {
                                ped[, i + 5] <- log(as.numeric(ped[, i + 5]) + 1)
                        }
                        else if (yml$impCOV[[i]][3] == 'sqr')
                        {
                                ped[, i + 5] <- (as.numeric(ped[, i + 5]))^2
                      }
		}
	}
}

# remove duplicate entries from phenotype file
ped <- unique(ped)

# export
write.table(ped, args[3], sep = " ", col.names = T, row.names = F, quote = F)
