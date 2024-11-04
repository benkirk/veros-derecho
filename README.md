# Building & Running Veros on Derecho

Utility scripts for running [Veros](https://veros.readthedocs.io/en/latest/) on Derecho.

## Quickstart
```pre
git clone https://github.com/benkirk/veros-derecho.git
cd veros-derecho

# (1) create a conda environment with Veros dependencies into ./veros-env/,
# (2) install Veros from github into that environment, and
# (3) install Veros examples into ./veros-tests/
make all
```

## Details
### Software Environment
The sourceable file `config_env.sh` defines the module selection and some path conveniences.  It will activate an existing `veros-env`, if any.

### Compiling
The script `create_veros_environment.sh` will create a conda environment with Veros dependencies into `./veros-env/`, install [Veros from github](https://github.com/team-ocean/veros) into that environment.  The script `create_veros_examples.sh` will install some examples and patch them to run on Derecho.
