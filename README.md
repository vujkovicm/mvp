# mvp

snakemake install documentation

problem 1: 	no internet access on GenISIS grid 
problem 2: 	no rights to install Anaconda packages in /group/tools/Anaconda/Anaconda3

workaround:	installation from source in a virtual environment

steps:
1. In home directory .bashrc put Anaconda3 as default:
        - export PATH="/group/tools/Anaconda/Anaconda3/bin:$PATH"
        - export LD_LIBRARY_PATH="/group/tools/Anaconda/Anaconda3/lib:$LD_LIBRARY_PATH"

2. download and install git on R04-WM Citrix 65 Desktop (single instance allowed)

3. clone git snakemake source files to /genxfer/to_gensis/vhaphileej
	- in Citrix Desktop, go to \\vashare.genisis.med.va.gov\genisis_xfer\to_genisis
	- right-click and select GIT BASH HERE
	- git clone https://bitbucket.org/snakemake/snakemake.git
	- in terminal, copy snakemake git from /genxfer/to_genisis/vhaphileej to /group/research/mvp001/snakemake
	- go to /group/research/mvp001/snakemake
	- create virtual environment to work around Anaconda3 package install limitation
	- virtualenv -p python3 .venv

4. download Anaconda packages in /genxfer/to_gensis/vhaphileej/pkgs
	- copy required packages to /group/research/mvp001/snakemake/.venv
	- go to .venv directory: unzip all packages: cat *.tar.bz2 | tar xvfj - -i
	- from snakemake directory, run: pip install --no-index file:/group/research/mvp001/snakemake
	- if there package dependencies, download them in genxfer pkgs and copy to .venv and unzip
	- then rerun the pip install command untill it gives you no errors
	- make sure to install conda conda-env and conda-build for proper functioning

5. Now that snakemake environment is functional, activate it: 
	- cd /group/research/mvp001/snakemake
	- source .venv/bin/activate
