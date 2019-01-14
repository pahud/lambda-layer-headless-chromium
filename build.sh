#!/bin/bash

[ ! -d ./layer/headless-chromium ] && mkdir -p ./layer/headless-chromium
docker run -dt --rm --name headless-chromium adieuadieu/headless-chromium-for-aws-lambda:stable
docker cp headless-chromium:/bin/headless-chromium ./layer/headless-chromium/
docker stop headless-chromium
chmod +x ./layer/headless-chromium/headless-chromium

# get Noto CJK fonts
mkdir .fonts .fonts-tmp
wget https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKtc-hinted.zip
unzip NotoSansCJKtc-hinted.zip -d .fonts-tmp
for i in Bold Medium Regular
do
   cp .fonts-tmp/NotoSansCJKtc-${i}.otf .fonts/
done
rm -rf NotoSansCJKtc-hinted* .fonts-tmp
chmod +r .fonts/*

# pack extra fonts in the bundle
cp -a .fonts ./layer/headless-chromium/
mkdir ./layer/headless-chromium/.fontconfig

# generate the font cache within docker
echo "generating the fontcache into .fontconfig"
bash docker_run.sh
cp .fontconfig/* ./layer/headless-chromium/.fontconfig/

echo "wrapping up..."
cd layer; zip -r ../layer.zip *
