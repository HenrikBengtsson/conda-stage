SHELL=bash

check: shellcheck spelling

shellcheck:
	cd bin; \
	shellcheck -s bash conda-stage.sh; \
	shellcheck -s bash incl/*.sh; \
	shellcheck conda-stage

spelling:
	Rscript -e "spelling::spell_check_files(c('README.md', 'NEWS.md'), ignore=readLines('WORDLIST'))"
	