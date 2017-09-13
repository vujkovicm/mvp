args = commandArgs(trailingOnly = T)

file.in  = paste0("summary/chp/", args[1], "/", args[1], ".locus.chp.maf", args[2], ".ref.snps")
file.lz  = paste0("summary/chp/", args[1], "/", args[1], ".locus.chp.maf", args[2], ".metal.out")

path.out = paste0("summary/chp/", args[1], "/locus/")

d <- read.table(file = file.in, header = T, as.is = T, sep = "\t")

for (iSNP in 1:nrow(d)) 
{
  refsnp  <- d$chrcbp[iSNP]
  SNP     <- gsub(":", "_", refsnp, fixed = T)      ### used in file name
  CHR     <- d$chr[iSNP]
  POS     <- d$pos[iSNP]

  ### content of the locuszoom script
  prefix_name     <- paste0(path.out, args[1], ".", SNP)

  ### bsub part
  job_name        <- SNP
  out_file_path   <- paste0(path.out, "OE_", job_name, ".o")
  err_file_path   <- paste0(path.out, "OE_", job_name, ".e")
  bsub_cmd        <- paste0("bsub -M 10000",
			" -J ", job_name, 
                        " -o ", out_file_path, 
                        " -e ", err_file_path)
  ### locuszoom part      
  lz_cmd  <- paste0("locuszoom",
                        " --metal ", file.lz, 
                        " --markercol CHRCBP",
                        " --pvalcol PVALUE",
                        " --chr ", CHR, 
                        " --refsnp ", refsnp, 
                        " --flank 500kb",
                        " --build hg19",
                        " --source 1000G_March2012",
                        " --pop EUR",
                        " --plotonly --no-date --cache None",
                        " --prefix ", prefix_name,
                        " --delim space")
  comb_cmd <- paste(bsub_cmd, lz_cmd)

  ### run locuszoom
  system(comb_cmd)
}       ### iSNP

