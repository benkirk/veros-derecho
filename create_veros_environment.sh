#!/usr/bin/env bash


#-------------------------------------------------------------------------------
# setup host environment
type module >/dev/null 2>&1 \
    || source /etc/profile.d/z00_modules.sh
module --force purge
module load ncarenv/23.09 gcc/12.2.0 ncarcompilers cray-mpich/8.1.27 cuda/12.2.1 mkl/2024.0.0 conda/latest cudnn/8.8.1.3-12
module list
#-------------------------------------------------------------------------------



cat <<EOF > veros-deps.yaml
name: mpi4jax
channels:
  - file:///glade/derecho/scratch/benkirk/conda-recipes/output
  - conda-forge

dependencies:
  - python =3.11
  - jax =*_derecho
  - jaxlib =*_derecho
  - h5py =*_derecho
  - mpi4jax =*_derecho
  - mpi4py =*_derecho
  - numpy <2
  - petsc4py =*_derecho
  - pip
  - pip:
     - setuptools
EOF
cat ./veros-deps.yaml

conda env create --file ./veros-deps.yaml --prefix ./veros-env
conda activate ./veros-env

# https://veros.readthedocs.io/en/latest/introduction/get-started.html
pip install git+https://github.com/team-ocean/veros@main

# https://veros-extra-setups.readthedocs.io/en/latest/installation.html:
pip install git+https://github.com/team-ocean/veros-extra-setups@main
conda list


#-------------------------------------------------------------------------------
#
cat <<EOF > derecho_jax_multigpu_init.py
# -- end of auto-generated header, original file below --

# -- NCAR / Derecho GPU Node jax.distributed initialization code follows --
import os
import jax
from mpi4py import MPI
comm = MPI.COMM_WORLD
shmem_comm = comm.Split_type(MPI.COMM_TYPE_SHARED)
LOCAL_RANK = shmem_comm.Get_rank()
WORLD_SIZE = comm.Get_size()
WORLD_RANK = comm.Get_rank()
#jax.distributed.initialize(cluster_detection_method="mpi4py",
#                           local_device_ids=LOCAL_RANK)
# rely on mpibind to have set visibility to 1-GPU per MPI rank already:
jax.distributed.initialize(cluster_detection_method="mpi4py",
                           local_device_ids=0)

if 0 == WORLD_RANK:
    print('-'*80)
    print('# jax environment:')
    jax.print_environment_info()
    print('jax.devices()={}'.format(jax.devices()))
    print('jax.process_count()={}'.format(jax.process_count()))
    print('jax.device_count()={}'.format(jax.device_count())) # total number of accelerator devices in the cluster
    print('jax.local_device_count()={}'.format(jax.local_device_count()))  # number of accelerator devices attached to this host
    print('-'*80)

# --end  NCAR / Derecho GPU Node jax.distributed initialization code --

EOF
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# setup examples
if [ ! -d ./veros-tests ]; then
       mkdir -p ./veros-tests
       veros copy-setup acc --to ./veros-tests/acc
       veros copy-setup wave_propagation --to ./veros-tests/wave_propagation
       veros copy-setup global_1deg --to ./veros-tests/global_1deg
fi
#-------------------------------------------------------------------------------


# don't forget:
# cd veros-tests/
# mpiexec -n 4 -ppn 4 veros run --backend jax --device gpu --force-overwrite wave_propagation/wave_propagation.py -n 2 2
# mpibind veros run --backend jax --device gpu --force-overwrite wave_propagation/wave_propagation.py -n 2 2
