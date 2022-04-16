# conda-stage

## Version 0.5.0-9000 [2022-04-15]

* ...


## Version 0.5.0 [2022-04-15]

Significant changes:

* Added `conda-stage --stage` for staging of Conda environment.

* Now `conda-stage` defaults to `conda-stage --help`.

* Now `conda-stage --stage` deactivates the original Conda environment
  before activating the staged one. Because of this, deactivation of
  the staged environment will _no longer_ revert back to the original
  environment.

New Features:

* Add `conda-stage --auto-unstage=enable` to automatically unstage a
  _staged_ Conda environment when deactivated.  The default value of
  `--auto-unstage` will be the same as `--auto-stage`, if that is
  specified.  To undo, call `conda-stage --auto-unstage=disable`.

* Now `conda-stage --auto-stage=enable` removes the previously cached
  'conda-pack' tarball, if it exists.


## Version 0.4.1 [2022-04-14]

Bug Fixes:

* `conda-stage --auto-stage=enable` could fail, because it did not
  created the '<env>/etc/conda/activate.d/' folder.


## Version 0.4.0 [2022-04-14]

Significant changes:

* Renamed option `--readonly` to `--read-only`.

New Features:

* Add `conda-stage --auto-stage=enable` to automatically stage a conda
  environment when activated.  Add `--read-only` to stage a read-only
  environment.  To undo, call `conda-stage --auto-stage=disable`.

Bug Fixes:

* `conda-stage --unstage` failed to remove read-only staged conda
  environments.


## Version 0.3.0 [2022-04-14]

New Features:

* Add `conda-stage --pack` to run `conda-pack` on an active conda
  environment and return.  Together with `--force`, this can be used
  to re-package an already packages environment.

* Report on progress when running `conda-pack`.  This can be disabled
  with option `--quiet`.

* Now verbose output has timing information for the different steps.

* Now an error is produced if installation of **conda-pack** failed.

* Now the 'conda-pack' tarball is created atomically by first
  outputting to a `.tmp.*.tar.gz` file, which is renamed to `*.tar.gz`
  on success.  This lowers the risk for ending up with a partially
  written `*.tar.gz` due to user interrupts or disk failures.

* Now the 'conda-pack':ed tarball is extracted atomically by
  extracting to a `*.tmp/` folder, which is renamed to `*/` on
  success.  This lowers the risk for partially staged conda
  environments.

Bug Fixes:

* `conda-stage()` choked on output message produced from installing
  `conda-pack`. Now such output is redirected to standard error, which
  makes them also visible to the end user.  This respects option
  `--quiet`.


## Version 0.2.0 [2022-04-13]

New Features:

* When used by Conda, the command-line prompt is now the name of the
  original Conda environment suffixed by an asterisk, e.g. `(myenv*)`.


## Version 0.1.1 [2022-04-13]

Bug Fixes:

* Failed to install **conda-pack** automatically.

* `conda-stage()` would choke on progress output by `conda-pack`.


## Version 0.1.0 [2022-04-13]

New Features:

* Add `conda-stage()` shell function for staging and unstaging conda
  environments on local disk.
