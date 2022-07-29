# Version (development version)

## Miscellaneous

* Wrap URL in two of the warnings within brackets to avoid the
  following colon to be part of the URL.


# Version 0.6.2 [2022-04-22]

## Miscellaneous

* Cleanup: `conda-stage --auto-stage=enable` now only adds one file
  per `activate.d/` and `deactivate.d/` folder of the Conda
  environment.  Previously, there was a second file used for optional
  debugging purposes.


# Version 0.6.1 [2022-04-19]

## New Features

* Now `conda-stage` detects if the cached 'conda-pack' tarball is out
  of date and re-packs it if needed.


# Version 0.6.0 [2022-04-18]

## Significant Changes

* Staged Conda environment are now read-only by default. This was done
  to make it more clear that packages updates and installs should be
  done toward the original, non-staged environment.

## New Features

* Added `--writable` to make a Conda environment writable. This must
  be set when configuring the environment or when manually staging
  it. It cannot be done on an already staged environment.

* Using `--quiet` with `--auto-stage=enable` will now make sure
  automatic staging during activation on the environment will be
  completely silent.

* An informative warning is now generated during staging if it is
  detected that the Conda environment has packages installed in its
  `pkgs/` folder. Such packages are _not_ staged by **conda-pack**,
  cf. <https://github.com/conda/conda-pack/issues/112>.

* Add option `--ignore-missing-files` which will be passed to
  `conda-pack` as-is.

# Version 0.5.1 [2022-04-16]

## Bug Fixes

* `conda active <env>` on a fresh Conda environment '<env>' configured
  to be auto-staged and _without_ 'conda-pack' installed, would fail
  to be staged.


# Version 0.5.0 [2022-04-15]

## Significant Changes

* Added `conda-stage --stage` for staging of Conda environment.

* Now `conda-stage` defaults to `conda-stage --help`.

* Now `conda-stage --stage` deactivates the original Conda environment
  before activating the staged one. Because of this, deactivation of
  the staged environment will _no longer_ revert back to the original
  environment.

## New Features

* Add `conda-stage --auto-unstage=enable` to automatically unstage a
  _staged_ Conda environment when deactivated.  The default value of
  `--auto-unstage` will be the same as `--auto-stage`, if that is
  specified.  To undo, call `conda-stage --auto-unstage=disable`.

* Now `conda-stage --auto-stage=enable` removes the previously cached
  'conda-pack' tarball, if it exists.


# Version 0.4.1 [2022-04-14]

## Bug Fixes

* `conda-stage --auto-stage=enable` could fail, because it did not
  created the '<env>/etc/conda/activate.d/' folder.


# Version 0.4.0 [2022-04-14]

## Significant Changes

* Renamed option `--readonly` to `--read-only`.

## New Features

* Add `conda-stage --auto-stage=enable` to automatically stage a conda
  environment when activated.  Add `--read-only` to stage a read-only
  environment.  To undo, call `conda-stage --auto-stage=disable`.

## Bug Fixes

* `conda-stage --unstage` failed to remove read-only staged conda
  environments.


# Version 0.3.0 [2022-04-14]

## New Features

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

## Bug Fixes

* `conda-stage()` choked on output message produced from installing
  `conda-pack`. Now such output is redirected to standard error, which
  makes them also visible to the end user.  This respects option
  `--quiet`.


# Version 0.2.0 [2022-04-13]

## New Features

* When used by Conda, the command-line prompt is now the name of the
  original Conda environment suffixed by an asterisk, e.g. `(myenv*)`.


# Version 0.1.1 [2022-04-13]

## Bug Fixes

* Failed to install **conda-pack** automatically.

* `conda-stage()` would choke on progress output by `conda-pack`.


# Version 0.1.0 [2022-04-13]

## New Features

* Add `conda-stage()` shell function for staging and unstaging conda
  environments on local disk.
