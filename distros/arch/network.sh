#/bin/bash

echo "Choose connection type[wifi/wired]"
read con
if [[ $con == "wired" ]]
then
interface=$(ip link | grep BROADCAST |  grep -o -P '(?<=:).*(?=:)' | sed 's: ::g')
cp /etc/netctl/examples/ethernet-dhcp /etc/netctl
sed s/Interface=eth0/Interface=$interface/g /etc/netctl/examples/ethernet-dhcp > /etc/netctl/ethernet-dhcp

netctl enable ethernet-dhcp
systemctl enable netctl-auto@ethernet-dhcp.service
systemctl enable netctl-ifplugd@ethernet-dhcp.service

reboot
elif [[ $con == "wifi" ]]
then
echo 'Enter SSID(if it contains $ symbol put \ before it)' 
read ssid

echo "Enter passphrase"
read pass

systemctl enable NetworkManager.service
systemctl start NetworkManager.service
nmcli device wifi list
nmcli device wifi connect $ssid password $pass
dhcpcd
reboot
fi
