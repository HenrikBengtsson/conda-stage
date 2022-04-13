SHELL=bash

shellcheck:
	cd bin; \
	shellcheck -x -s bash conda-stage.sh; \
	shellcheck -x -s bash incl/*.sh; \
	shellcheck -x conda-stage
