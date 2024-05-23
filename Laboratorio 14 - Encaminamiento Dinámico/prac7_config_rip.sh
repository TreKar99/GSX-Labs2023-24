#!/bin/bash

touch /etc/quagga/zebra.conf

if [[ $(hostname) == "router1" ]]; then
	cp /root/ripd.conf.r1 /etc/quagga/ripd.conf
	iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
else
	cp /root/ripd.conf /etc/quagga/ripd.conf
fi

# Ajustar els permisos
chown -R quagga.quaggavty /etc/quagga/
chmod 640 /etc/quagga/*.conf

# Reengegar els dos serveis
/etc/init.d/zebra restart
/etc/init.d/ripd restart
