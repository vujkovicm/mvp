rm(list=ls())
args = commandArgs(trailingOnly = TRUE)

# test
# args = c("pheno/T2D_datacube.modified.csv", "pop/MVP001.AFR.ids", "pop/MVP001.AFR.pca")

library('yaml')
library('data.table')

yml = yaml.load_file('config/imp-assoc.yaml')

### PHENO + PCA 
cube  	= read.table(args[1], header = T, as.is = T, sep = "|")
pop 	= read.table(args[2], header = T, as.is = T)
pca 	= read.table(args[3], header = T, stringsAsFactors = F, sep = " ")

### MERGE  
phe 	 = merge(pop, cube, by.x = "fid", by.y = "mvp001_id", all.x = T)
phe = data.table(phe)
pca = data.table(pca)
keep = union(names(phe), names(pca))
phe = data.frame(pca[phe, mget(keep), on = "fid", nomatch = NA])

### PED
ped 	= phe[, c("fid", "iid", "fatid", "matid", "sex0")]
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
write.table(ped, args[4], sep = " ", col.names = T, row.names = F, quote = F)
