rm(list=ls())

args = commandArgs(trailingOnly = TRUE)

# usage [python 2.7]:
# Rscript scripts/R/imp/impLocusRun.R 'phe' 'pop' 'nfo' 'maf'
# Rscript scripts/R/imp/impLocusRun.R 'T2D' 'EUR' '0.6' '0.01' 

out_fold_path	<- paste0("/group/research/mvp001/snakemake/summary/imp/", args[1], "/regional")
OE_fold_path	<- paste0("/group/research/mvp001/snakemake/summary/imp/", args[1], "/OE")
in_file		<- paste0("/group/research/mvp001/snakemake/summary/imp/", args[1], "/", args[1], ".", args[2], ".imp.info", args[3], ".maf", args[4], ".score.locus.ref")
lz_input_path	<- paste0("/group/research/mvp001/snakemake/summary/imp/", args[1], "/", args[1], ".", args[2], ".imp.info", args[3], ".maf", args[4], ".score.all") 

# import
d <- read.table(in_file, header = T, sep = "\t", stringsAsFactors = F)

# IF pop = EUR, AFR, AMR then use that reference G1K population, if META then use EUR
pop = ifelse(args[2] == "META", "EUR", args[2])

for (iSNP in 1:nrow(d)) {
	refsnp	<- d$chrcbp[iSNP]
	SNP	<- gsub(":", "_", refsnp, fixed=T)	### used in file name
	CHR	<- d$chr[iSNP]
	POS	<- d$pos[iSNP]

		### content of the locuszoom script
	prefix_name	<- paste0(out_fold_path, "/", args[1], "_", args[2])
	
		### bsub part
	#job_name	<- paste0("NAFLD_", SNP)
	job_name	<- "separate"
	out_file_path	<- paste0(OE_fold_path, "/OE_", job_name, "_", SNP, "_", args[2], ".o")
	err_file_path	<- paste0(OE_fold_path, "/OE_", job_name, "_", SNP, "_", args[2], ".e")
	bsub_cmd	<- paste0("bsub -M 10000 -q short ",
				" -J ", job_name, 
				" -o ", out_file_path, 
				" -e ", err_file_path)
	
			### locuszoom part	
	lz_cmd	<- paste0("locuszoom",
			" --metal ", lz_input_path, 
			" --markercol CHRCBP",
			" --pvalcol PVALUE",
			" --chr ", CHR, 
			" --refsnp ", refsnp, 
			" --flank 500kb",
			" --build hg19",
			" --source 1000G_March2012",
			" --pop ", pop,
			" --plotonly --no-date --cache None",
			" --prefix ", prefix_name,
			" --delim tab")

	comb_cmd	<- paste(bsub_cmd, lz_cmd)
	system(comb_cmd)
}
