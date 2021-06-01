#!/bin/bash

echo "
    ____  __________       ____  ____  __________________    ___________
   / __ \/ ____/ __ \     / __ \/ __ \/_  __/ ____/  _/ /   / ____/ ___/
  / /_/ / __/ / / / /    / / / / / / / / / / /_   / // /   / __/  \__ \
 / _, _/ /___/ /_/ /    / /_/ / /_/ / / / / __/ _/ // /___/ /___ ___/ /
/_/ |_/_____/_____/____/_____/\____/ /_/ /_/   /___/_____/_____//____/
                 /_____/
"

username=$(whoami)
if [[ $username = 'root' ]]
then
echo "you cant install it from root user"
exit 0
fi
echo "Hello $username"
sleep 2
echo "installing packages"
sleep 1
sudo cp ./sources.list /etc/apt
sudo apt update
sudo apt dist-upgrade
sudo apt install $(cat ./packages)
echo "done"
echo "installing .config directory"
sleep 1
cp -r ../../.config /home/$username
echo "done"
echo "intalling vim config"
sleep 1
cp -r ../../.vim ../../.vimrc /home/$username
sudo cp -r ../../.vim ../../.vimrc /root
echo "done"
echo "installing zsh config"
sleep 1
cp -r ../../.zshrc ../../.p10k.zsh ../../.oh-my-zsh /home/$username
chsh -s /usr/bin/zsh
echo "done"
echo "installing todo"
sleep 1
cp -r ../../.todo /home/$username
echo "done"
echo "updating grub"
sleep 1
gfx=$(grep GRUB_GFXMODE /etc/default/grub)
sed s/"$gfx"/GRUB_GFXMODE=1920x1080/g /etc/default/grub > log
sudo bash -c "cat log > /etc/default/grub"
rm log
sudo grub-mkconfig -o /boot/grub/grub.cfg
echo "setting sound"
sleep 1
sudo echo "options snd_usb_audio index=1" /etc/modprobe.d/alsa.conf
echo "defaults.ctl.card 1;
defaults.pcm.card 1;" > /home/$username/.asoundrc
echo "done"
echo "installing src directory"
sleep 1
cp -r src /home/$username
echo "done"
echo "installing font"
sleep 1
cd font
./font.sh
cd ..
echo "done"
echo "downloading todo.sh"
sleep 1
git clone $(cat packages_git | head -1 | tail -1)
cd todo.txt-cli
sudo make install
cd ..
echo "done"
echo "installing gtk"
sleep 1
cp -r ../../.themes ../../.icons ../../.gtkrc-2.0 ~
echo "done"
echo "vim.desktop"
sleep 1
sudo cp ./vim.desktop /usr/share/applications/
echo "done"
echo "installing st"
sleep 1
cd ../../st
sudo make clean install
echo "done"
cd
echo "exec bspwm" > ~/.xinitrc
sudo reboot
