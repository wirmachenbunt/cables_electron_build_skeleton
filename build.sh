#!/bin/bash
set -e

source .env
echo $PATCH_NAME
echo "PATCHNAME IS ${PATCH_NAME}"
if [[ "${PATCH_NAME}" == "" ]]; then
  PATCH_NAME="patch"
fi
echo "PATCHNAME IS ${PATCH_NAME}"

patchname=${3:-skip}
zip=${2:-skip}
platform=${1?please specify platform to build for};

cd patch/
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
    zip -qr ../${PATCH_NAME}-${platform}.zip *
fi
