#!/bin/sh

DIR=`pwd`

cd /data
npm install

sudo apt-get install -y libbluetooth-dev 

cd "$DIR"
npm start -- --userDir /data
