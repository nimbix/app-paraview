#!/usr/bin/env bash

set -e

mkdir -p /tmp/test_data
cd /tmp/test_data

paraviewVersion="$PARAVIEW_VERSION"
paraviewMajorVersion="$(echo $paraviewVersion | tr "." " " | awk '{print $1}')"
paraviewMinorVersion="$(echo $paraviewVersion | tr "." " " | awk '{print $2}')"
paraviewPatchVersion="$(echo $paraviewVersion | tr "." " " | awk '{print $3}')"

downloadURL="https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v${paraviewMajorVersion}.${paraviewMinorVersion}&type=data&os=Sources&downloadFile=ParaViewTestingDataFiles-v${paraviewVersion}.tar.gz"

curl -L "$downloadURL" | tar xz --strip-components=1

mkdir -p "/opt/paraview_build/share/paraview-${paraviewMajorVersion}.${paraviewMinorVersion}/doc"
cp -r "/tmp/test_data/Testing/Data" "/opt/paraview_build/share/paraview-${paraviewMajorVersion}.${paraviewMinorVersion}/examples"

rm -rf /tmp/test_data
