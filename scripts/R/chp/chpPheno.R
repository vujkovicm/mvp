rm(list=ls())
args = commandArgs(trailingOnly = TRUE)

# test
# args = c("pheno/NAFLD_datacube.modified.csv", "pop/MVP001.EUR.pca")

library('yaml')
yml = yaml.load_file('config/chp-assoc.yaml')

### PHENO + PCA 
cube  	= read.table(args[1], T, sep = " ", stringsAsFactors = F)
pca 	= read.table(args[2], header = T, stringsAsFactors = F, sep = " ")

### MERGE  
phe 	= merge(pca, cube, by.x = "fid", by.y = "mvp001_id", all.x = T)

### PED
ped 	  = phe[, c("fid", "iid", "fatid", "matid")]
ped$n_sex = 0
for(i in 1:length(yml$chpCOV))
{
	ped = cbind.data.frame(ped, phe[, yml$chpCOV[[i]][[1]][1]])
	colnames(ped)[i + 5] = names(yml$chpCOV)[i]
	# ped[, i + 5] = 0
	# now fill out a little better 
	if(length(yml$chpCOV[[i]]) == 3)
	{
		# category to numeric
		if(yml$chpCOV[[i]][2] %in% c('B', 'D'))
		{
			tmp <- ped[, i + 5]
                        tmp <- ifelse(ped[,i + 5]  == yml$chpCOV[[i]][3], '1', ifelse(ped[,i + 5] == "", NA, '2'))
                        ped[,i + 5] <- tmp
		}
		else if(yml$chpCOV[[i]][2] %in% c('P', 'C'))
                {
                        if(yml$chpCOV[[i]][3] == 'int')
                        {
                                ped[, i + 5] <- ifelse(is.na(as.numeric(ped[, i + 5])), NA, qnorm((rank(as.numeric(ped[, i + 5])) - 3/8) / (nrow(ped) + 1/4)))
                        }
                        else if (yml$chpCOV[[i]][3] == 'log')
                        {
                                ped[, i + 5] <- log(as.numeric(ped[, i + 5]) + 1)
                        }
                        else if (yml$chpCOV[[i]][3] == 'sqr')
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
