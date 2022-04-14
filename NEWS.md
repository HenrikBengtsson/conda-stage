# conda-stage

## Version 0.2.0-9005 [2022-04-14]

New Features:

* Report on progress when running `conda-pack`.  This can be disabled
  with option `--quiet`.

* Now `conda-pack` creates the tarball atomically by first outputting
  to a `.tmp.*.tar.gz` file, which is renamed to `*.tar.gz` on success.
  This lowers the risk for ending up with a partially written
  `*.tar.gz` due to user interrupts or disk failures.

Bug Fixes:

* `conda-stage()` choked on output message produced from installing
  `conda-pack`. Now such output is redirected to standard error, which
  makes them also visible to the end user.  This respects option
  `--quiet`.


## Version 0.2.0 [2022-04-13]

New Features:

* When used by Conda, the command-line prompt is now the name of the
  original conda environment suffixed by an asterisk, e.g. `(myenv*)`.


## Version 0.1.1 [2022-04-13]

Bug Fixes:

* Failed to install **conda-pack** automatically.

* `conda-stage()` would choke on progress output by `conda-pack`.


## Version 0.1.0 [2022-04-13]

New Features:

* Add `conda-stage()` shell function for staging and unstaging conda
  environments on local disk.
