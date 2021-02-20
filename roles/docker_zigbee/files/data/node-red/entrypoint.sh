#!/bin/sh

DIR=`pwd`

cd /data
npm install

sudo apt-get install -y libbluetooth-dev libudev-dev pi-bluetooth

cd "$DIR"
npm start -- --userDir /data
