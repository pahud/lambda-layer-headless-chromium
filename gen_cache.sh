#!/bin/bash

fc-cache -r  .fonts/
cp $(grep Noto /var/cache/fontconfig/* | awk '{print $3}') .fontconfig/

