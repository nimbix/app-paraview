# Must be built...
FROM ubuntu:focal
LABEL maintainer="Nimbix, Inc." \
      license="BSD"

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20221028.1000}

# Install dependencies
RUN apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        cmake \
        git \
        libgl1-mesa-dev \
        libopenmpi-dev \
        libqt5help5 \
        libqt5svg5-dev \
        libqt5x11extras5-dev \
        libtbb-dev \
        libxt-dev \
        ninja-build \
        python3-dev \
        python3-numpy \
        python3-pygments \
        qt5-default \
        qttools5-dev \
        qtxmlpatterns5-dev-tools

# Clone and build Paraview
WORKDIR /opt/
RUN git clone https://gitlab.kitware.com/paraview/paraview.git && \
    mkdir paraview_build && \
    cd paraview && \
    git checkout v5.10.2 && \
    git submodule update --init --recursive && \
    cd ../paraview_build && \
    cmake -GNinja -DPARAVIEW_USE_PYTHON=ON -DPARAVIEW_USE_MPI=ON -DVTK_SMP_IMPLEMENTATION_TYPE=TBB -DCMAKE_BUILD_TYPE=Release ../paraview && \
    ninja && \
    cd /opt/ && find . -name "*.o" | xargs rm

# Install image-common with desktop
RUN apt-get -y update && \
    apt-get -y install curl && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
        | bash -s -- --setup-nimbix-desktop

COPY scripts /usr/local/scripts

COPY NAE/screenshot.png /etc/NAE/screenshot.png
COPY NAE/AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://cloud.nimbix.net/api/jarvice/validate

RUN mkdir -p /etc/NAE && touch /etc/NAE/{screenshot.png,screenshot.txt,license.txt,AppDef.json}
