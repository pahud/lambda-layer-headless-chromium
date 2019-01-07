#!/bin/bash

docker run -ti -v "$PWD":/var/task \
-v "$PWD/.fonts":/opt/headless-chromium/.fonts \
-v "$PWD/.fontconfig":/opt/headless-chromium/.fontconfig \
-it lambci/lambda:build-python3.6 bash gen_cache.sh

