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
$ conda activate myenv
(myenv) $ conda-stage --auto-stage=enable
(myenv) $ conda deactivate
$ 
```

This configuration is only needed to be done once per environment.

Now, whenever activating this environment in the future, it will be automatically staged;

```sh
$ conda activate myenv
(/tmp/alice/conda-stage-ktdy/myenv) $ command -v python
/tmp/hb/conda-stage-ktdy/myenv/bin/python
```

When deactivate, all temporarily files will be removed automatically;

```sh
(/tmp/alice/conda-stage-ktdy/myenv) $ conda deactivate
INFO: Unstaging and reverting to original Conda environment  ...
INFO: Preparing removal of staged files: /tmp/hb/conda-stage-ktdy/myenv
INFO: Deactivating and removing staged Conda environment: /tmp/hb/conda-stage-ktdy/myenv
INFO: Total unstage time: 0 seconds
$ 
```

To temporarily disable automatic staging when activating the environment, set environment variable `CONDA_STAGE=false` before activation, e.g.

```sh
$ CONDA_STAGE=false conda activate myenv
(myenv) $ 
```

This can be useful to reconfigure the environment, because you cannot configure the environment when staged;

```sh
$ CONDA_STAGE=false conda activate myenv
(myenv) $ conda-stage --auto-stage=disable
(myenv) $ conda deactivate
$
```


### Example: Manual staging and unstaging of environments

To stage conda environment 'myenv' to local disk and activate there, do:

```sh
$ conda activate myenv
(myenv) $ which python
/home/alice/.conda/envs/myenv/bin/python
(myenv) $ conda-stage --stage --quiet
(myenv*) $ which python
/tmp/alice/conda-stage-VlQr/myenv/bin/python
```

To unstage, that is, reactivate the original environment 'myenv' and remove all staged files, do:

```sh
(myenv*) $ conda-stage --unstage --quiet
(myenv) $ which python
/home/alice/.conda/envs/myenv/bin/python
(myenv) $ conda deactivate
$ 
```

For further help, call:

```sh
$ conda-stage --help
```


## Requirements

* **Bash**
* [**conda**](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html), e.g. Miniconda or Anaconda

All heavy lifting is done by [**conda-pack**](https://conda.github.io/conda-pack/), which is a tool for packaging and distributing conda environments.  If not already installed, it will be installed into the active environment before that is staged to local disk.


## Installation

```sh
$ cd /path/to/software
$ curl -L -O https://github.com/HenrikBengtsson/conda-stage/archive/refs/tags/0.4.1.tar.gz
$ tar xf 0.4.1.tar.gz
$ PATH=/path/to/conda-stage-0.4.1/bin:$PATH
$ export PATH
$ conda-stage --version
0.4.1
```
