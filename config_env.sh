#-------------------------------------------------------------------------------
# setup host environment
topdir=$(git rev-parse --show-toplevel)

type module >/dev/null 2>&1 \
    || source /etc/profile.d/z00_modules.sh
module --force purge
module load ncarenv/23.09 gcc/12.2.0 ncarcompilers cray-mpich/8.1.27 cuda/12.2.1 mkl/2024.0.0 conda/latest cudnn/8.8.1.3-12
module list

[ -d ${topdir}/veros-env ] && conda activate ${topdir}/veros-env
#-------------------------------------------------------------------------------
