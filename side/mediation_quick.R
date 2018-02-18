# more accurante display than 2e-16 for p-values in R

# set working directory
setwd("/group/research/mvp001/snakemake/out/chp")

# import 
# N.B. Europeans + PCA's selected according to HARE definition (Assimes lab)
snp = read.table("TCF7L2.raw", sep = " ", T, stringsAsFactors = F)
pad = read.table("pad_vars.txt", sep = " ", T, stringsAsFactors = F)
t2d = read.table("PHECODE.EUR.phe", sep = " ", T, stringsAsFactors = F)

# merge 3 datasets into 1 data frame
df = merge(snp, merge(t2d, pad, all = T, by.y = "mvp001_id", by.x = "FID"), all.x = T, by = "FID")

# cleanup and keep relevant variables
df = df[, c("FID", "AX.11652775_T", "SEX.y", "age", "p_pad5c", "p_pad_control", "PHECODE", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")]
colnames(df)[1:7] = c("mvp001_id", "rs7903146", "sex", "age", "pad_case", "pad_cntrl", "t2d")
df$pad = ifelse(df$pad_case == 1, 1, ifelse(df$pad_cntrl == 1, 0, NA))

table(df$pad)
#      0      1
# 199258  26102

# Mediation analysis
# Difference method (standard approach)
# M1: E[pad, E=snp, C=asl] = β0 + β1 e + β2 c
# M2: E[pad, E=snp, M=t2d, C=asl] = θ0 + θ1 e + θ2 m + θ3 c
#
#
# Direct effect of exposure (snp) on outcome (pad) = θ1
# Indirect effect of exposure (snp) through mediator (t2d) on outcome (pad) = β1 - θ1
#
m1 = glm(pad ~ rs7903146 + age + sex + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data = df, family = "binomial")
m2 = glm(pad ~ rs7903146 + t2d + age + sex + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data = df, family = "binomial")

