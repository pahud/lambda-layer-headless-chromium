#!/bin/bash
# headless-chromium will load fontcache from ~/.fontconfig so we work this around
# by specifying /opt/headless-chromium as $HOME so we can load the cache from /opt/headless-chromium/.fontconfig
# make sure you import pahud/headless-chromium-layer already.

export HOME=/opt/headless-chromium
S3_BUCKET='s3://pahud-tmp-nrt'

url="https://www.momoshop.com.tw/main/Main.jsp"
headless-chromium \
--headless \
--disable-dev-shm-usage \
--ignore-certificate-errors \
--no-sandbox \
--hide-scrollbars \
--disable-gpu \
--single-process \
--window-size=1600,2400 \
--screenshot=/tmp/screenshot.png $url

# unset HOME to avoid possible issues
unset HOME
# generate the screenshot, uploading to S3 and generate presigned URL
aws s3 cp /tmp/screenshot.png ${S3_BUCKET}/screenshot.png && \
aws s3 presign ${S3_BUCKET}/screenshot.png --expires-in $((60*5))


