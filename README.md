[![shellcheck](https://github.com/HenrikBengtsson/conda-stage/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/HenrikBengtsson/conda-stage/actions/workflows/shellcheck.yml)


# conda-stage: Stage Conda Environment on Local Disk

The `conda-stage` tool takes the active conda environment and stage it to local disk. Working with a conda environment on local disk can greatly improve the performance as local disk is often much faster than a global, network-based file system, including multi-tenant parallel file systems such as BeeGFS and Lustre often found in high-performance compute (HPC) environments.


## Setup

Call the following _once_ per shell session:

```sh
$ eval $(conda-stage --source)
```

This will create shell _function_ `conda-stage()`.


## Examples

### Example: Configure environment for automatic staging

To _configure_ existing Conda environment 'myenv' so that it is automatically staged to local disk when activated, and automatically unstaged when deactivated, do:

```sh
$ conda-stage --auto-stage=enable myenv
INFO: Configuring automatic staging and unstaging of original Conda environment  ...
INFO: Package current Conda environment (/home/alice/.conda/envs/myenv) to cache ...
INFO: [ONCE] Packaging Conda environment, because it hasn't been done before ...
Collecting packages...
Packing environment at '/home/alice/.conda/envs/myenv' to '/home/alice/.conda/envs/.tmp.myenv.tar.gz'
[########################################] | 100% Completed |  8.4s
INFO: Total 'conda-pack' time: 10 seconds
INFO: Created conda-pack tarball: /home/alice/.conda/envs/myenv.tar.gz (140098670 bytes; 2025-03-02 18:09:55.975267674 -0800)
INFO: Enabled auto-staging
INFO: Enabled auto-unstaging
$ 
```

This configuration is only needed to be done once per environment.

Now, whenever activating this environment in the future, it will be automatically staged;

```sh
$ conda activate myenv
INFO: Staging current Conda environment (/home/alice/.conda/envs/myenv) to local disk ...
INFO: Extracting /home/alice/.conda/envs/myenv.tar.gz (140098719 bytes; 2025-03-02 18:18:24.957895743 -0800) to /tmp/alice/conda-stage-ktdy/myenv
INFO: Total extract time: 2 seconds
INFO: Disable any /tmp/alice/conda-stage-yOri/myenv/etc/conda/activate.d/*.conda-stage-auto.sh scripts
INFO: Activating staged environment
INFO: Unpacking (relocating)
INFO: Total 'conda-unpack' time: 0 seconds
INFO: Making staged environment read-only (use --writable to disable)
INFO: Activating staged Conda environment: /tmp/alice/conda-stage-ktdy/myenv
(/tmp/alice/conda-stage-ktdy/myenv) $ command -v python
/tmp/alice/conda-stage-ktdy/myenv/bin/python
```

When deactivate, all temporarily files will be removed automatically;

```sh
(/tmp/alice/conda-stage-ktdy/myenv) $ conda deactivate
INFO: Unstaging and reverting to original Conda environment  ...
INFO: Preparing removal of staged files: /tmp/alice/conda-stage-ktdy/myenv
INFO: Deactivating and removing staged Conda environment: /tmp/alice/conda-stage-ktdy/myenv
INFO: Total unstage time: 0 seconds
$ 
```

To temporarily disable automatic staging, set environment variable `CONDA_STAGE=false` before activation, e.g.

```sh
$ export CONDA_STAGE=false
$ conda activate myenv
(myenv) $ 
```

This can be useful when you want to update the Conda environment, or install additional software, because that cannot be done to staged environment;

```sh
$ export CONDA_STAGE=false
$ conda activate myenv
(myenv) $ conda update --all
(myenv) $ conda-stage --pack --force
(myenv) $ conda deactivate
$ unset CONDA_STAGE
$
```

We call `conda-stage --pack --force` to make sure the updated are reflected in the cached "tarball" that is used for staging.

To disable auto-staging, do:

```sh
$ conda-stage --auto-stage=disable myenv
INFO: Configuring automatic staging and unstaging of original Conda environment  ...
INFO: Removed 'conda-pack' tarball /home/alice/.conda/envs/myenv.tar.gz (140098670 bytes; 2025-03-02 18:09:55.975267674 -0800)
INFO: Disabled auto-staging
INFO: Disabled auto-unstaging
```


### Example: Manual staging and unstaging of environments

To stage conda environment 'myenv' to local disk and activate there, do:

```sh
$ conda activate myenv
(myenv) $ which python
/home/alice/.conda/envs/myenv/bin/python
(myenv) $ conda-stage --stage --quiet
(/tmp/alice/conda-stage-VlQr/myenv) $ which python
/tmp/alice/conda-stage-VlQr/myenv/bin/python
```

To unstage, that is, reactivate the original environment 'myenv' and remove all staged files, do:

```sh
(/tmp/alice/conda-stage-VlQr/myenv) $ conda-stage --unstage --quiet
(myenv) $ which python
/home/alice/.conda/envs/myenv/bin/python
(myenv) $ conda deactivate
$ 
```


## Environment modules

The `conda-stage` tool can be provided via an environment module, e.g.

```sh
module load conda-stage
```

An minimal Lua module ("Lmod") that will:

1. Adds the `conda-stage` tool to the search path

2. Creates the `conda-stage()` function (replaces `eval $(conda-stage
   --source)`)
   
3. Configures auto-staging to load the module when activating the
   Conda environment

is:

```lua
prepend_path("PATH","/path/to/conda-stage/bin")
set_shell_function('conda-stage', 'source "/path/to/conda-stage/bin/conda-stage.sh"; conda-stage "$@"', '')
pushenv("CONDA_STAGE_PROLOGUE","module load conda-stage")
```


## Command-line help

```sh
$ conda-stage --help --full
conda-stage: Stage Conda Environment on Local Disk

Usage:
 conda-stage [options] [env_name]

Basic options:  
 --help                  Display the full help page with examples
 --version               Output version of this software
 --full                  Output expanded help and version information

Output options:
 --debug                 Output detailed debug information
 --quiet                 Silence all output

Auto-staging options:
 --auto-stage=<cmd>      'enable' or 'disable' automatic staging when
                         activating a Conda environment
 --auto-unstage=<cmd>    'enable' or 'disable' automatic unstaging when
                         deactivating the staged Conda environment
 --prologue=<commands>   Optional commands to call during autostaging
                         before 'conda-stage' is called the first time

Manual-staging options:
 --stage                 Stage a Conda environment
 --unstage               Unstage and remove staged environment

Conda-pack options:
 --ignore-missing-files  Passed to 'conda-pack' as-is

Other options:
 --writable              Make the staged environment writable
 --assert=<what>         Assert that environment is 'staged' or 'unstaged'
 --path=<path>           Directory where Conda environment should be
                         staged (Default: 'mktemp -d')
 --pack                  Package up a Conda environment
 --force                 Force an action, e.g. repacking environment
 --source                Output conda-stage() shell function

Arguments:
 env_name                An optional environment name
                         (Default: the current activated environment)

Examples:

 conda-stage --help --full
 conda-stage --version
 conda-stage --version --full

 ## Enable auto-staging
 conda-stage --auto-stage=enable myenv

 ## Disable auto-staging
 conda-stage --auto-stage=disable myenv

 ## Auto-stage when 'conda-stage' module needs to be "loaded" first
 conda-stage --prologue="module load conda-stage" --auto-stage=enable myenv

 ## Alternatively, set a default --prologue command
 export CONDA_STAGE_PROLOGUE="module load conda-stage"
 conda-stage --auto-stage=enable myenv

 ## Repack environment after updating or install new software
 conda-stage --pack --force

 ## Manual staging: Bash only
 eval "$(conda-stage --source)"
 conda activate myenv
 conda-stage --stage

 ## Manual staging: Other shells
 conda activate myenv
 stage_path=$(mktemp -d)
 conda-stage --stage --path="${stage_path}"
 source "${stage_path}/bin/activate"

Environment variables:
 CONDA_STAGE            (logical) enable or disable Conda staging
 CONDA_STAGE_DEBUG      (logical) alternative to --debug
 CONDA_STAGE_VERBOSE    (logical) alternative to --verbose
 CONDA_STAGE_WRITABLE   (logical) alternative to --writable
 CONDA_STAGE_ALLOW_BASE (logical) stage "base" environment (experimental)
 CONDA_STAGE_PATH       (string)  alternative to --path=<path>
 CONDA_STAGE_PROLOGUE   (string)  alternative to --prologue=<commands>
 CONDA_STAGE_LOGFILE    (string)  option logging to file
 CONDA_STAGE_STAGED     (logical) is environment staged? (read-only)
 CONDA_STAGE_AUTOSTAGED (logical) is environment auto-staged? (read-only)

Requirements:
 * Bash
 * conda-pack (automatically installed into Conda environment, if missing)
 * conda

Version: 0.8.0-9000
Copyright: Henrik Bengtsson (2022-2025)
License: ISC
Webpage: https://github.com/HenrikBengtsson/conda-stage/
```


## Known limitations

* An already staged Conda environment cannot be staged.

* `RPATH` (= run-time search path) in binaries are not
  rewritten/relocated by **conda-pack** by staging,
  cf. <https://github.com/conda/conda-pack/issues/117>.  This means
  that those binaries will still access the original files as pointed
  to by `RPATH`. This will not break anything.


## Requirements

* **Bash**

* [**conda**](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html), e.g. Miniforge (~500 MB disk space), Miniconda (~900 MB disk space) or Anaconda (~3 TB disk space). Commands `conda activate ...` and `conda deactivate` works in conda (>= 4.6) [2019-01-15].

All heavy lifting is done by [**conda-pack**](https://conda.github.io/conda-pack/), which is a tool for packaging and distributing conda environments.  If not already installed, it will be installed into the active environment before that is staged to local disk.


## Installation

```sh
$ cd /path/to/software
$ curl -L -O https://github.com/HenrikBengtsson/conda-stage/archive/refs/tags/0.8.0-9000.tar.gz
$ tar xf 0.8.0-9000.tar.gz
$ PATH=/path/to/conda-stage-0.8.0-9000/bin:$PATH
$ export PATH
$ conda-stage --version
0.8.0-9000
```