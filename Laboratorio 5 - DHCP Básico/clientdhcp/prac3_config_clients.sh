# Permitir acceso root ssh
cp sshd_config /etc/ssh/sshd_config
systemctl restart ssh

# Apagar eth0
ifdown eth0

# Send hostname and lease-time 24h
cp ./dhclient.conf /etc/dhcp/dhclient.conf

# Encender eth0
ifup eth0
