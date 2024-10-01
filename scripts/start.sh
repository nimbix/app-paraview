#!/usr/bin/env bash

set -e

cd /data || true

# Temporary check for the PS1 variable for terminal
if [[ -z "${PS1}" ]]; then
  echo "export PS1=\"[\u@\h: \w]\$ \"" >> $HOME/.bashrc
fi

exec /opt/paraview_build/bin/paraview
