FROM ubuntu:focal
LABEL maintainer="Nimbix, Inc." \
      license="BSD"

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20221011.1003}

# Install image-common tools and desktop
RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install curl ca-certificates --no-install-recommends && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/jarvice-desktop/fixs_1/install-nimbix.sh \
        | bash

# Install Paraview
WORKDIR /usr/local/paraview
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install libxkbcommon-x11-0 libxkbcommon0 libxcb* libopengl0
RUN curl \
    "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.10&type=binary&os=Linux&downloadFile=ParaView-5.10.1-MPI-Linux-Python3.9-x86_64.tar.gz" \
    | tar xz --strip-components=1

COPY scripts /usr/local/scripts

COPY NAE/screenshot.png /etc/NAE/screenshot.png
COPY NAE/AppDef.json /etc/NAE/AppDef.json
# RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://cloud.nimbix.net/api/jarvice/validate

RUN mkdir -p /etc/NAE && touch /etc/NAE/{screenshot.png,screenshot.txt,license.txt,AppDef.json}
