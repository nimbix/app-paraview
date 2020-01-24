FROM ubuntu:bionic
LABEL maintainer="Nimbix, Inc." \
      license="BSD"

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20191204.1230}

# Install image-common with desktop
RUN apt-get -y update && \
    apt-get -y install curl && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/image-common/master/install-nimbix.sh \
        | bash -s -- --setup-nimbix-desktop && \
    apt-get -y install paraview

# Install Paraview
WORKDIR /usr/local/src
#RUN curl -O "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.7&type=binary&os=Linux&downloadFile=ParaView-5.7.0-MPI-Linux-Python2.7-64bit.tar.gz"
#RUN tar xf "download.php?submit=Download&version=v5.7&type=binary&os=Linux&downloadFile=ParaView-5.7.0-MPI-Linux-Python2.7-64bit.tar.gz"
##RUN tar xf ParaView-5.7.0-MPI-Linux-Python2.7-64bit.tar.gz
#
#RUN mv /usr/local/src/ParaView-5.7.0-MPI-Linux-Python2.7-64bit /usr/local/ParaView
#RUN rm "/usr/local/src/download.php?submit=Download&version=v5.1&type=binary&os=linux64&downloadFile=ParaView-5.1.2-Qt4-OpenGL2-MPI-Linux-64bit.tar.gz"
COPY scripts /usr/local/scripts

COPY NAE/screenshot.png /etc/NAE/screenshot.png
COPY NAE/AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate
