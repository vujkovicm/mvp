# Remarks:
# europeans + PCA's selected according to HARE definition (Assimes lab)
# pad is a composite variable of p_pad5c (cases) and p_pad_control (controls) (could be totally wrong here)
# e.g. the case and control counts do not completely overlap with the MVP PAD powerpoint by Klarin & Damrauer

# extend display of p-values from 2e-16 to 2e-309 for p-values in R
.Machine$double.eps = .Machine$double.xmin

# set working directory
setwd("/group/research/mvp001/snakemake/out/chp")

# import 
snp = read.table("TCF7L2.raw", sep = " ", T, stringsAsFactors = F)
pad = read.table("pad_vars.txt", sep = " ", T, stringsAsFactors = F)
t2d = read.table("PHECODE.EUR.phe", sep = " ", T, stringsAsFactors = F)

# merge 3 datasets into 1 data frame
df = merge(snp, merge(t2d, pad, all = T, by.y = "mvp001_id", by.x = "FID"), all.x = T, by = "FID")

# cleanup 
df = df[, c("FID", "AX.11652775_T", "SEX.y", "age", "p_pad5c", "p_pad_control", "PHECODE", "PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10")]
colnames(df)[1:7] = c("mvp001_id", "rs7903146", "sex", "age", "pad_case", "pad_cntrl", "t2d")

# define PAD
df$pad = ifelse(df$pad_case == 1, 1, ifelse(df$pad_cntrl == 1, 0, NA))

# Frequency of PAD in EUR MVP 
table(df$pad)
#      0      1
# 199258  26102

# mediation analysis (product method)
# M1: E[pad, E=snp, C=cov] = β0 + β1 e + β2 c
# M2: E[pad, E=snp, M=t2d, C=cov] = θ0 + θ1 e + θ2 m + θ3 c
#
# Direct effect of exposure (snp) on outcome (pad) = θ1
# Indirect effect of exposure (snp) on outcome (pad) through mediator (t2d) = β1 * θ2

m1 = glm(pad ~ rs7903146 + age + sex + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data = df, family = "binomial")
m2 = glm(pad ~ rs7903146 + t2d + age + sex + PC1 + PC2 + PC3 + PC4 + PC5 + PC6 + PC7 + PC8 + PC9 + PC10, data = df, family = "binomial")

# M1: Model 1
# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -4.307e+00  6.488e-02 -66.386  < 2e-16 ***
# rs7903146    4.538e-02  1.055e-02   4.303 1.69e-05 ***
# age          4.416e-02  6.156e-04  71.731  < 2e-16 ***
# sex         -6.667e-01  4.129e-02 -16.147  < 2e-16 ***
# PC1          2.415e+01  3.286e+00   7.352 1.96e-13 ***
# PC2         -4.989e+00  3.285e+00  -1.519 0.128865    
# PC3          1.124e+01  3.295e+00   3.411 0.000647 ***
# PC4         -2.340e+01  3.326e+00  -7.035 2.00e-12 ***
# PC5          2.303e-01  3.396e+00   0.068 0.945943    
# PC6          6.550e+00  3.405e+00   1.924 0.054405 .  
# PC7          2.820e+00  3.400e+00   0.830 0.406817    
# PC8         -1.298e+00  3.401e+00  -0.381 0.702842    
# PC9          8.671e+00  3.402e+00   2.549 0.010802 *  
# PC10         3.779e+00  3.405e+00   1.110 0.267092    
---

# M2: Model 2
# Coefficients:
#               Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -5.510e+00  7.964e-02 -69.186  < 2e-16 ***
# rs7903146    1.484e-03  1.212e-02   0.123   0.9025    
# t2d          9.902e-01  1.581e-02  62.610  < 2e-16 ***
# age          4.299e-02  7.501e-04  57.315  < 2e-16 ***
# sex         -5.831e-01  4.596e-02 -12.689  < 2e-16 ***
# PC1          2.101e+01  3.765e+00   5.581 2.39e-08 ***
# PC2          5.201e+00  3.782e+00   1.375   0.1691    
# PC3          8.716e+00  3.773e+00   2.310   0.0209 *  
# PC4         -2.301e+01  3.863e+00  -5.955 2.60e-09 ***
# PC5          3.058e+00  3.907e+00   0.783   0.4338    
# PC6          5.372e+00  3.912e+00   1.373   0.1697    
# PC7          2.988e+00  3.899e+00   0.767   0.4433    
# PC8         -3.135e+00  3.901e+00  -0.804   0.4217    
# PC9          7.072e+00  3.907e+00   1.810   0.0703 .  
# PC10         4.929e+00  3.904e+00   1.262   0.2068    
# ---

# Results
# Direct effect of exposure (rs7903146) on outcome (pad) 
# θ1 
0.001485

# Indirect effect of exposure (rs7903146) on outcome (pad) through mediator (t2d) 
# β1 * θ2 
# 0.04538 * 0.990157 
0.04493

# Conclusion
# Effect of rs7903146 on PAD is for 99% (0.0449/0.0454) mediated (explained) trough it's effect on T2D.
# Will have to do a formal mediation analysis to come up with SE, CI, and P.
