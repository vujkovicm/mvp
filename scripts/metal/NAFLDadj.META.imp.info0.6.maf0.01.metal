SCHEME STDERR
CUSTOMVARIABLE N_INFORMATIVE
LABEL N_INFORMATIVE AS N_INFORMATIVE

MARKER CHRCBP
FREQ AF
ALLELE REF ALT
EFFECT EFFECT
PVALUE PVALUE
WEIGHTLABEL N_INFORMATIVE
STDERR SE

AVERAGEFREQ ON
MINMAXFREQ ON
COLUMNCOUNTING STRICT
SEPERATOR WHITESPACE
PROCESS summary/imp/NAFLDadj/NAFLDadj.EUR.imp.info0.6.maf0.01.wald.out
PROCESS summary/imp/NAFLDadj/NAFLDadj.AMR.imp.info0.6.maf0.01.wald.out
PROCESS summary/imp/NAFLDadj/NAFLDadj.AFR.imp.info0.6.maf0.01.wald.out

OUTFILE summary/imp/NAFLDadj/NAFLDadj.META.imp.info0.6.maf0.01.meta_ .out
ANALYZE HETEROGENEITY
QUIT
