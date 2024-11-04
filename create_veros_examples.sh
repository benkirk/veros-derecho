#!/usr/bin/env bash

#------------------------------------------------------------------
# common config
topdir=$(git rev-parse --show-toplevel)
source ${topdir}/config_env.sh
#------------------------------------------------------------------

#-------------------------------------------------------------------------------
# setup examples
echo "Creating examples..."
mkdir -p ./veros-tests

for exe in "acc" "north_atlantic" "global_1deg"; do
    cd ${topdir}
    veros copy-setup ${exe} --to ./veros-tests/${exe}
    if [ -f ./veros-tests/${exe}/${exe}.py ]; then
        cd ./veros-tests/${exe}
        make -f ${topdir}/Makefile derecho_${exe}.py
    fi
done
#-------------------------------------------------------------------------------


# don't forget:
# cd veros-tests/
# mpiexec -n 4 -ppn 4 veros run --backend jax --device gpu --force-overwrite wave_propagation/wave_propagation.py -n 2 2
# mpibind veros run --backend jax --device gpu --force-overwrite wave_propagation/wave_propagation.py -n 2 2
