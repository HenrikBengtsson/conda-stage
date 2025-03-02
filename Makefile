SHELL=bash

check: shellcheck spelling

README.md: README.md.tmpl bin/conda-stage
	@bfr=$$(cat "$<"); \
	help=$$(bin/conda-stage --help --full); \
	version=$$(bin/conda-stage --version); \
	bfr=$$(echo "$${bfr/\{\{ HELP \}\}/$${help}}"); \
	bfr=$$(echo "$${bfr//\{\{ VERSION \}\}/$${version}}"); \
	printf "$${bfr}" > $@

shellcheck:
	cd bin; \
	shellcheck -s bash conda-stage.sh; \
	shellcheck -s bash incl/*.sh; \
	shellcheck conda-stage

spelling:
	Rscript -e "spelling::spell_check_files(c('README.md', 'NEWS.md'), ignore=readLines('WORDLIST'))"
