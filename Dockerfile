# Copyright (c) 2025, Nimbix, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are
# those of the authors and should not be interpreted as representing official
# policies, either expressed or implied, of Nimbix, Inc.

FROM rockylinux/rockylinux:9

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER}

ARG PARAVIEW_VERSION

COPY --from=us-docker.pkg.dev/jarvice/images/mpi-builder:4.1.6 /opt/JARVICE /opt/JARVICE

RUN dnf install epel-release -y && \
    crb enable && \
    dnf update -y && \
    dnf group install -y "Development Tools" && \
    dnf install -y \
        cmake\
        git\
        ninja-build\
        python3-devel\
        qt5-qtbase-devel\
        qt5-qtsvg-devel\
        qt5-qttools-devel\
        qt5-qtwebengine-devel\
        qt5-qtxmlpatterns-devel\
        tbb-devel\
        wget &&\
    dnf clean all

# Clone and build Paraview
WORKDIR /opt/
RUN git clone https://gitlab.kitware.com/paraview/paraview.git && \
    mkdir paraview_build && \
    cd paraview && \
    git checkout v${PARAVIEW_VERSION} && \
    git submodule update --init --recursive && \
    cd ../paraview_build && \
    . /opt/JARVICE/jarvice_mpi.sh && \
    CFLAGS="-s" CXXFLAGS="-s" cmake -GNinja -DPARAVIEW_USE_PYTHON=ON -DPARAVIEW_USE_MPI=ON -DVTK_SMP_IMPLEMENTATION_TYPE=TBB -DCMAKE_BUILD_TYPE=Release ../paraview && \
    ninja -j 16 && \
    cd /opt/ && find . -name "*.o" | xargs rm

# Install jarvice-desktop tools and desktop
ARG BRANCH=master
RUN dnf install -y ca-certificates wget && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/jarvice-desktop/${BRANCH}/install-nimbix.sh \
        | bash -s -- --jarvice-desktop-branch ${BRANCH}

COPY scripts /usr/local/scripts

COPY NAE/screenshot.png /etc/NAE/screenshot.png
COPY NAE/license.txt /etc/NAE/license.txt
COPY NAE/AppDef.json /etc/NAE/AppDef.json
RUN sed -i s",PARAVIEW_VERSION,${PARAVIEW_VERSION}," /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://cloud.nimbix.net/api/jarvice/validate

RUN mkdir -p /etc/NAE && touch /etc/NAE/screenshot.png /etc/NAE/screenshot.txt /etc/NAE/license.txt /etc/NAE/AppDef.json /etc/NAE/swlicense.txt
