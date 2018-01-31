rm(list=ls())
args = commandArgs(trailingOnly = TRUE)

# Anaconda python v2.7

# test
# Rscript scripts/R/imp/impLocusRun.R 'NAFLDadj' 'AFR' '0.6' '0.01' 

out_fold_path	<- paste0("summary/imp/", args[1], "/regional")
OE_fold_path	<- paste0("summary/imp/", args[1], "/OE")

in_file		<- paste0("summary/imp/", args[1], "/", args[1], ".", args[2], ".imp.info", args[3], ".maf", args[4], ".wald.locus.ref")

d <- read.table(in_file, header = T, sep = "\t", stringsAsFactors = F)

lz_input_path	<- paste0("summary/imp/", args[1], "/", args[1], ".", args[2], ".imp.info", args[3], ".maf", args[4], ".wald.out") 

for (iSNP in 1:nrow(d)) {
	refsnp	<- d$chrcbp[iSNP]
	SNP	<- gsub(":", "_", refsnp, fixed = T)
	CHR	<- d$chr[iSNP]
	POS	<- d$pos[iSNP]

		### content of the locuszoom script
	prefix_name	<- paste0(out_fold_path, "/", args[1], "_", args[2])
	job_name	<- "separate"
	out_file_path	<- paste0(OE_fold_path, "/OE_", job_name, ".o")
	err_file_path	<- paste0(OE_fold_path, "/OE_", job_name, ".e")
	bsub_cmd	<- paste0("bsub -M 10000 -q short ",
				" -J ", job_name, 
				" -o ", out_file_path, 
				" -e ", err_file_path)
		### locuszoom part	
	lz_cmd	<- paste0("locuszoom",
			" --metal ", lz_input_path, 
			" --markercol SNP",
			" --pvalcol P",
			" --chr ", CHR, 
			" --refsnp ", refsnp, 
			" --flank 500kb",
			" --build hg19",
			" --source 1000G_March2012",
			" --pop ", args[2],
			" --plotonly --no-date --cache None",
			" --prefix ", prefix_name,
			" --delim space")
		### submit command
	comb_cmd	<- paste(bsub_cmd, lz_cmd)
	system(comb_cmd)
}	 
