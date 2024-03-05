#!/usr/bin/env bash

set -e

cd /data || true

# Get number of nodes and cores
CORES=$(wc -l /etc/JARVICE/cores | awk '{print $1}')

# Start the server
eval mpirun -np $CORES --hostfile /etc/JARVICE/nodes /opt/paraview_build/bin/pvserver 1> /tmp/server-mpi.log 2> /tmp/server-mpi-err.log &

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

# Start paraview and connect to the mpi cluster
set +e
eval /opt/paraview_build/bin/paraview --url $PSERVER_URL
ERR=$?
exit $ERR
