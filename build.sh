#!/bin/bash
set -e

zip=${2:-skip}
platform=${1?please specify platform to build for};

cd src/
npm install
cd ..

mkdir -p build
cd build;
rm -rf ${platform};
mkdir -p ${platform};
cd ${platform};
cp -r ../../electron/${platform}/* .
if [[ $platform == linux* ]]; then
    mkdir -p resources/app/
    cp -r ../../patch/* resources/app/
    mv electron patch
    chmod 755 patch
elif [[ $platform == darwin* ]]; then
    mkdir -p Electron.app/Contents/Resources/app/
    cp -r ../../patch/* Electron.app/Contents/Resources/app/
    mv Electron.app patch.app
elif [[ $platform == win* ]]; then
    mkdir -p resources/app/
    cp -r ../../patch/* resources/app/
    mv electron.exe patch.exe
else
    echo "could not determine target platform from ${platform}";
    exit 1;
fi

if [[ "${zip}" == "zip" ]]; then
    zip -qr ../patch-${platform}.zip *
fi
