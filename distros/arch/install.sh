#/bin/bash

echo "username"
read username

echo "password"
read password

echo "hostname"
read hostname

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

pacman --noconfirm -Sy $(cat ./packages)

useradd -m -G wheel,video,audio,storage,power -s /bin/bash $username

echo "$username:$password" | chpasswd 

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

echo "$username ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

sudo -u $username git clone https://github.com/redmaun/reddotfiles.git /home/$username/reddotfiles

sudo -u $username git clone https://aur.archlinux.org/yay.git /home/$username/yay
cd /home/$username/yay
sudo -u $username makepkg --noconfirm -i
cd -

sudo -u $username yay --noconfirm -S $(cat ./packages_aur)

gfx=$(grep GRUB_GFXMODE /etc/default/grub)
sed s/"$gfx"/GRUB_GFXMODE=1920x1080/g /etc/default/grub > log
cat log > /etc/default/grub
rm log
grub-mkconfig -o /boot/grub/grub.cfg

sudo -u $username cp -r /home/$username/reddotfiles/.config /home/$username
sudo -u $username cp -r /home/$username/reddotfiles/.zshrc /home/$username/reddotfiles/.p10k.zsh /home/$username/reddotfiles/.oh-my-zsh /home/$username
sudo -u $username cp -r /home/$username/reddotfiles/distros/arch/src /home/$username
sudo -u $username cp /home/$username/reddotfiles/.gtkrc-2.0 /home/$username

sudo -u $username mkdir /home/$username/.fonts
sudo -u $username cp /home/$username/reddotfiles/distros/arch/fonts/* /home/$username/.fonts
sudo -u $username fc-cache -fv

sudo -u $username chsh -s /usr/bin/zsh

ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
hwclock --systohc

sudo -u $username git config --global credential.helper store

systemctl enable pulseaudio.service

echo "$hostname" > /etc/hostname

sudo -u $username echo "exec bspwm" > /home/$username/.xinitrc

sed -e '$ d' /etc/sudoers > temp
cp temp /etc/sudoers
rm temp

reboot
