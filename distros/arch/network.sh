#/bin/bash

interface=$(ip link | grep BROADCAST |  grep -o -P '(?<=:).*(?=:)' | sed 's: ::g')
cp /etc/netctl/examples/ethernet-dhcp /etc/netctl
sed s/Interface=eth0/Interface=$interface/g /etc/netctl/examples/ethernet-dhcp > /etc/netctl/ethernet-dhcp

netctl enable ethernet-dhcp
systemctl enable netctl-auto@ethernet-dhcp.service
systemctl enable netctl-ifplugd@ethernet-dhcp.service

reboot
