#/bin/bash

sudo cp -avr ./bitmap/ /usr/share/fonts
sudo cp ./fontconfig/10-scale-bitmap-fonts.conf /etc/fonts/conf.d
sudo cp ./fontconfig/70-yes-bitmaps.conf /etc/fonts/conf.d
sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
fc-cache -fv

