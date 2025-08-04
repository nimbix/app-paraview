#!/usr/bin/env bash

set -e

cd /data || true

# Temporary check for the PS1 variable for terminal
if [[ -z "${PS1}" ]]; then
  echo "export PS1=\"[\u@\h: \w]\$ \"" >> $HOME/.bashrc
fi

# Loop through optional inputs
SCRIPT=""
while [ -n "$1" ]; do
  case "$1" in
  -script)
    shift
    echo "INFO: Python Script File: $1"
    SCRIPT="--script=$1"
    ;;
  *) ;;
  esac
  shift
done

mkdir -p "$HOME/.xdg_runtime"
chmod -R 0700 "$HOME/.xdg_runtime"
export XDG_RUNTIME_DIR="$HOME/.xdg_runtime"
export RUNLEVEL=3

cmd="/opt/paraview_build/bin/paraview $SCRIPT"
echo "INFO: Running $cmd"
set +e
eval "$cmd"
ERR=$?
set -e
exit $ERR
