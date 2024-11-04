#!/usr/bin/env bash

#------------------------------------------------------------------
# common config
topdir=$(git rev-parse --show-toplevel)
source ${topdir}/config_env.sh
#------------------------------------------------------------------

cat <<EOF > veros-deps.yaml
name: veros-deps
channels:
  - file:///glade/derecho/scratch/benkirk/conda-recipes/output
  - conda-forge

dependencies:
  - python =3.11
  - h5py =*_derecho
  - jax =*_derecho
  - jaxlib =*_derecho
  - mpi4jax =*_derecho
  - mpi4py =*_derecho
  - numpy <2
  - petsc4py =*_derecho
  - pip
  - pip:
     - setuptools
EOF
cat ./veros-deps.yaml

conda deactivate
conda env create --file ./veros-deps.yaml --prefix ./veros-env
conda activate ./veros-env

# https://veros.readthedocs.io/en/latest/introduction/get-started.html
pip install git+https://github.com/team-ocean/veros@main

# https://veros-extra-setups.readthedocs.io/en/latest/installation.html:
pip install git+https://github.com/team-ocean/veros-extra-setups@main
conda list
