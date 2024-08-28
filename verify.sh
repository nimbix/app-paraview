#!/usr/bin/env bash

ENTRY_POINT=${1:-start.sh}

# Get latest image
IMAGE=$(podman images | grep paraview | head -n1 | awk '{print $1 ":" $2}')
if [[ -z $IMAGE ]]; then
    echo "ERROR: Paraview image not found..."
    exit 1
fi

podman run -it --rm --shm-size=16g -p 5902:5902 --entrypoint=bash "$IMAGE" -ec "
    useradd --shell /bin/bash nimbix
    mkdir -p /home/nimbix/
    mkdir -p /data
    mkdir -p /etc/JARVICE
    chown -R nimbix:nimbix /home/nimbix
    chown -R nimbix:nimbix /data
    chown -R nimbix:nimbix /etc/JARVICE
    echo 127.0.0.1 > /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 > /etc/JARVICE/nodes
    echo JOB_NAME=Local_Testing >> /etc/JARVICE/jobinfo.sh
    su nimbix -c '
        cd \$HOME
        /usr/local/bin/nimbix_desktop /usr/local/scripts/$ENTRY_POINT
    '
"
