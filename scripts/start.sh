#!/usr/bin/env bash

cd /data || true

if grep --quiet VGL_DISPLAY /etc/JARVICE/vglinfo.sh; then
  exec /usr/local/bin/nimbix_desktop /usr/local/paraview/bin/paraview
else
  exec /usr/local/bin/nimbix_desktop /usr/local/paraview/bin/paraview-mesa paraview
fi
