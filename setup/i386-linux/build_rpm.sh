#!/bin/bash
mkdir /tmp/build
cp output/*.deb /tmp/build
cd /tmp/build
sudo alien -r /tmp/build/*.deb
#rm -r $BuildDir
