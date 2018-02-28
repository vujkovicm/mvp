# split CHRCBP into chr and position
awk '{split($1, a, ":"); print a[1]"\t"a[2]}' test.txt > loci.txt
sed -i 's/^chr//g' loci.txt
sed -i.bak "1s/^.*/CHR\tPOS/" loci.txt

# add loci to output
paste loci.txt test.txt > tmp1.txt

# Alleles to upper case
awk '$4 = toupper($4)' tmp1.txt > tmp2.txt
awk '$5 = toupper($5)' tmp2.txt > tmp3.txt

# select columns and reorder
awk '{print $3,$1,$2,$4,$5,$7,$15,$8,$14}' tmp3.txt > MVP_UKB_DIAGRAM.all

# rename header
sed -i.bak "1s/^.*/CHRCBP CHR POS EA NEA FFECT SE PVALUE N_INFORMATIVE/" MVP_UKB_DIAGRAM.all
