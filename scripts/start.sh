#!/usr/bin/env bash

set -e

cd /data || true

exec /opt/paraview_build/bin/paraview
