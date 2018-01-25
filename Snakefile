configfile: 	"config/chp-assoc.yaml"
configfile: 	"config/imp-assoc.yaml"

include:	"rules/imp-assoc.rules"
include:	"rules/imp-target.rules"
include:	"rules/chp-assoc.rules"
include:	"rules/chp-target.rules"

# run jobs like a boss 
# snakemake -j 900 --keep-going -c "bsub -M 30960" target
