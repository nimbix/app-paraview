#!/usr/bin/env bash

set -e

cd /data || true

# Get number of nodes and cores
CORES=$(wc -l /etc/JARVICE/cores | awk '{print $1}')

# Setup MPI
JARVICE_FOLDER=/opt/JARVICE
export PATH=$JARVICE_FOLDER/openmpi/bin/:$JARVICE_FOLDER/bin/:$PATH
export LD_LIBRARY_PATH=$JARVICE_FOLDER/openmpi/lib/:$JARVICE_FOLDER/lib/:$LD_LIBRARY_PATH
export CPATH=$JARVICE_FOLDER/openmpi/include/:$JARVICE_FOLDER/include/:$CPATH
export MPI_HOME=$JARVICE_FOLDER/openmpi/
export MPI_RUN=$JARVICE_FOLDER/openmpi/bin/mpirun

# Start the server
cmd="$(which $MPI_RUN) -np $CORES --hostfile /etc/JARVICE/nodes /opt/paraview_build/bin/pvserver"
echo "INFO: Starting MPI Server -> $cmd"
eval "$cmd" 1> /tmp/server-mpi.log 2> /tmp/server-mpi-err.log &

# Wait for the start up to happen
PSERVER_URL=""
COUNT=0
while [[ -z $PSERVER_URL && $COUNT -lt 6 ]]; do
    sleep 5
    PSERVER_URL=$(grep Connection /tmp/server-mpi.log | awk '{print $3}')
    COUNT=$((COUNT+1))
done

if [[ -z $PSERVER_URL ]]; then
    echo "ERROR: Paraview Server did not start. Exiting..."
    exit 1
fi

echo "INFO: MPI server starting completed"

# Temporary check for the PS1 variable for terminal
if [[ -z "${PS1}" ]]; then
  echo "export PS1=\"[\u@\h: \w]\$ \"" >> $HOME/.bashrc
fi

# Start paraview and connect to the mpi cluster
cmd="/opt/paraview_build/bin/paraview --url \"$PSERVER_URL\""
echo "INFO: Running $cmd"
set +e
eval "$cmd"
ERR=$?
set -e
exit $ERR
