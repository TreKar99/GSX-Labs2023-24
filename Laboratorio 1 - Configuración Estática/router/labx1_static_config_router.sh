# Asignar primera IP disponible del rango
ip addr add 198.18.124.1/28 dev eth1
ip link set eth1 up

# Activar IPv4 forwarding de forma permanente
cp sysctl.conf /etc/sysctl.conf
echo 1 > /proc/sys/net/ipv4/ip_forward

# Añadir server a /etc/hosts
cp hosts /etc/hosts

# Permitir salida a internet
iptables -t nat -A POSTROUTING -s 198.18.124.0/28 -o eth0 -j MASQUERADE

# Permitir acceso root a ssh
cp sshd_config /etc/ssh/sshd_config
