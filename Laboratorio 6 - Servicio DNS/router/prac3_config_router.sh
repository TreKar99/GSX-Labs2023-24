# Asignar primera IP disponible del rango (eth1)
ip addr flush dev eth1
ip addr add 198.18.124.1/28 dev eth1
ip link set eth1 up

# Activar IPv4 forwarding de forma permanente
cp sysctl.conf /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

# Permitir salida a internet (DMZ)
iptables -t nat -A POSTROUTING -s 198.18.124.0/28 -o eth0 -j MASQUERADE

# Permitir acceso root a ssh
cp sshd_config /etc/ssh/sshd_config

# Asignar primera IP disponible del rango (eth2)
ip addr flush dev eth2
ip addr add 172.24.124.1/25 dev eth2
ip link set eth2 up

# Permitir salida a internet (intranet)
iptables -t nat -A POSTROUTING -s 172.24.124.0/25 -o eth0 -j MASQUERADE

# Configurar el client dhcp
ifdown eth0
cp ./dhclient.conf /etc/dhcp/dhclient.conf
ifup eth0

# Contenidors sols puguin consultar al nostre DNS
iptables -A FORWARD -p udp --dport 53 ! -s 198.18.124.14 ! -d 198.18.124.14 -j DROP
iptables -A FORWARD -p tcp --dport 53 ! -s 198.18.124.14 ! -d 198.18.124.14 -j DROP

# Redirigiu tots els queries DNS que arribin a la eth0 del router redirigint-lo
iptables -t nat -A PREROUTING -i eth0 -d $(hostname -I | awk '{print $1}') -p udp --dport 53 -j DNAT --to-destination 198.18.124.14:53
iptables -t nat -A PREROUTING -i eth0 -d $(hostname -I | awk '{print $1}') -p tcp --dport 53 -j DNAT --to-destination 198.18.124.14:53
iptables -t nat -A PREROUTING -i eth1 -d $(hostname -I | awk '{print $2}') -p udp --dport 53 -j DNAT --to-destination 198.18.124.14:53
iptables -t nat -A PREROUTING -i eth1 -d $(hostname -I | awk '{print $2}') -p tcp --dport 53 -j DNAT --to-destination 198.18.124.14:53
iptables -t nat -A PREROUTING -i eth2 -d $(hostname -I | awk '{print $3}') -p udp --dport 53 -j DNAT --to-destination 198.18.124.14:53
iptables -t nat -A PREROUTING -i eth2 -d $(hostname -I | awk '{print $3}') -p tcp --dport 53 -j DNAT --to-destination 198.18.124.14:53
