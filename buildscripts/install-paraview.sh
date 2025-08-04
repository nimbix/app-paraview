#!/usr/bin/env bash

set -e

cd /opt
git clone https://gitlab.kitware.com/paraview/paraview.git

mkdir paraview_build

cd paraview

git checkout v${PARAVIEW_VERSION}
git submodule update --init --recursive

cd ../paraview_build
. /opt/JARVICE-MPI/jarvice_mpi.sh

CFLAGS="-s" CXXFLAGS="-s" cmake \
    -GNinja \
    -DPARAVIEW_USE_PYTHON=ON \
    -DPARAVIEW_USE_MPI=ON \
    -DVTK_SMP_IMPLEMENTATION_TYPE=TBB \
    -DCMAKE_BUILD_TYPE=Release \
    ../paraview

ninja -j 16

cd /opt/
find . -name "*.o" | xargs rm
