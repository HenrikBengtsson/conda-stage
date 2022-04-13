# conda-stage: Stage Conda Environment on Local Disk

## Example

```sh
$ eval $(conda-stage --source)
$ conda activate myenv
$ conda-stage
$ which python
/tmp/alice/conda-stage_VlQrpSj0BT/bin/python
$ ...
$ conda deactivate
```

## Requirements

* **Bash**
* [**conda**](https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html), e.g. Miniconda or Anaconda
* [**conda-pack**](https://conda.github.io/conda-pack/)


## Installing conda-pack in conda environment

```sh
$ conda activate myenv
$ conda install -c conda-forge conda-pack
$ conda-pack --version
```
