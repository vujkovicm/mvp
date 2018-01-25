### snakemake install in a virtual environment

Steps:
1. In home directory .bashrc put Anaconda3 as default:
	- export PATH="/group/tools/Anaconda/Anaconda3/bin:$PATH"
	- export LD_LIBRARY_PATH="/group/tools/Anaconda/Anaconda3/lib:$LD_LIBRARY_PATH"

2. download and install git on R04-WM Citrix 65 Desktop (single instance allowed)

3. clone git snakemake source files to grid
	- in Citrix Desktop, go to to_genisis folder
	- right-click and select GIT BASH HERE
	- git clone https://bitbucket.org/snakemake/snakemake.git
	- in terminal, copy snakemake git from to_genisis/vhaxxxxxxxxx to /snakemake folder
	- go to /snakemake folder
	- create virtual environment to work around Anaconda3 package install limitation
	- virtualenv -p python3 .venv

4. download Anaconda packages in to_gensis/vhaxxxxxxxxx folder
	- copy required packages to /snakemake/.venv
	- go to .venv directory: unzip all packages: cat *.tar.bz2 | tar xvfj - -i
	- from snakemake directory, run: pip install --no-index file:/snakemake
	- if there package dependencies, download them in genxfer pkgs and copy to .venv and unzip
	- then rerun the pip install command untill it gives you no errors
	- make sure to install conda conda-env and conda-build for proper functioning

5. Now that snakemake environment is functional, activate it: 
	- cd /snakemake
	- source .venv/bin/activate
