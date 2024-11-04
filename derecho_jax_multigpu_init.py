# -- begin NCAR / Derecho GPU Node jax.distributed initialization code follows --
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

# -- end  NCAR / Derecho GPU Node jax.distributed initialization code --
