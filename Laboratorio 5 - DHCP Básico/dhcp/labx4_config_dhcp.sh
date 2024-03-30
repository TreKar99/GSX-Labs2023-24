# Comprobamos que se esté ejecutando en modo root
if [ $EUID -ne 0 ]; then
	echo " El script debe ejecutarse en modo root." >&2
	exit 1
fi

# Asignar ultima IP disponible del rango
cp interfaces /etc/network/interfaces
ifdown eth0 2</dev/null && ifup eth0 2</dev/null

# Permitir acceso root ssh
cp sshd_config /etc/ssh/sshd_config
systemctl restart ssh

# Poner al router como DNS
cp resolv.conf /etc/resolv.conf

# Comprobar si isc-dhcp-server instalado y si no instalarlo
if [ -z "$(apt list --installed 2</dev/null | grep isc-dhcp-server 2</dev/null)" ];
then
	apt install isc-dhcp-server -y;
fi

# Configuramos dhcp 
cp ./dhcpd.conf /etc/dhcp/dhcpd.conf

# Hacer que escuche en la eth0
cp ./isc-dhcp-server /etc/default/isc-dhcp-server

# Reiniciamos servicio dhcp
systemctl enable isc-dhcp-server.service
systemctl start isc-dhcp-server.service
