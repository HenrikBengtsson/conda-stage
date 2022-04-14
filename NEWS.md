# conda-stage

## Version 0.2.0-9001 [2022-04-14]

New Features:

* Report on progress when running `conda-pack`.


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
