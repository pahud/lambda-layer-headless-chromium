#!/bin/bash

dir=' /opt/headless-chromium'
fc-cache -r  $dir/.fonts/
cp $(grep Noto /var/cache/fontconfig/* | awk '{print $3}') $dir/.fontconfig/

