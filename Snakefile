configfile: "config/assoc-chp.yaml"

include:
	"rules/target.rules"
include:
	"rules/assoc-chp.rules"

# run jobs like a boss 
# snakemake -j 900 --keep-going -c "bsug -M 30960" target
