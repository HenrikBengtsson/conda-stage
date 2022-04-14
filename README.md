[![shellcheck](https://github.com/HenrikBengtsson/conda-stage/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/HenrikBengtsson/conda-stage/actions/workflows/shellcheck.yml)


# conda-stage: Stage Conda Environment on Local Disk

The `conda-stage` tool takes the active conda environment and stage it to local disk. Working with a conda environment on local disk can greatly improve the performance as local disk is often much faster than a global, network-based file system, including multi-tenant parallel file systems such as BeeGFS and Lustre often found in high-performance compute (HPC) environments.


## Setup

Call the following _once_ per shell session:

```sh
$ eval $(conda-stage --source)
```

This will create shell _function_ `conda-stage()`.


## Example

To stage conda environment 'myenv' to local disk and activate there, do:

```sh
$ conda activate myenv
(myenv) $ which python
/home/alice/.conda/envs/myenv/bin/python
(myenv) $ conda-stage
(myenv*) $ which python
/tmp/alice/conda-stage_VlQrpSj0BT/bin/python
```

To unstage, that is, reactivate the original environment 'myenv' and remove all staged files, do:

```sh
(myenv*) $ conda-stage --unstage
(myenv) $ conda-stage
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

All heavy lifting is done by [**conda-pack**](https://conda.github.io/conda-pack/) a tool for packaging and distributing conda environments.  If not already installed, it will be installed into the active environment before its staged to local disk.


## Installation

```sh
$ cd /path/to/software
$ curl -L -O https://github.com/HenrikBengtsson/conda-stage/archive/refs/tags/0.2.0.tar.gz
$ tar xf 0.2.0.tar.gz
$ PATH=/path/to/conda-stage-0.2.0/bin:$PATH
$ export PATH
$ conda-stage --version
0.2.0
```
