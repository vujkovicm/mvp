configfile: 	"config/chp-assoc.yaml"
configfile: 	"config/imp-assoc.yaml"

include: "rules/chp-assoc.rules"
include: "rules/chp-assoc.rules"

include: "rules/imp-target.score"
include: "rules/imp-assoc.score"

include: "rules/imp-assoc.wald"
include: "rules/imp-target.wald"
  
# run jobs like a boss 
# snakemake -j 900 --keep-going -c "bsub -M 30960" target
