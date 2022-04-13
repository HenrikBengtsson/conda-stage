SHELL=bash

shellcheck:
	cd bin; \
	shellcheck -x -s bash conda-stage.sh; \
	shellcheck -x -s bash incl/*.sh; \
	shellcheck -x conda-stage

spelling:
	Rscript -e "spelling::spell_check_files(c('README.md'), ignore=readLines('WORDLIST'))"
