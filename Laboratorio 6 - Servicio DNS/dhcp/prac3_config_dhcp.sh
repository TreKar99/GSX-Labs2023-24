# Comprobamos que se esté ejecutando en modo root
if [ $EUID -ne 0 ]; then
	echo " El script debe ejecutarse en modo root." >&2
	exit 1
fi

# Asignar ultima IP disponible del rango
ifdown eth0
cp interfaces /etc/network/interfaces
ifup eth0

# Permitir acceso root ssh
cp sshd_config /etc/ssh/sshd_config
systemctl restart ssh

# Poner al router como DNS
cp resolv.conf.extern.dns /etc/resolv.conf

# Comprobar si isc-dhcp-server instalado y si no instalarlo
if [ -z "$(apt list --installed 2</dev/null | grep isc-dhcp-server 2</dev/null)" ];
then
	apt install isc-dhcp-server -y;
fi

# Configuramos dhcp
ifdown eth0
cp ./dhcpd.conf /etc/dhcp/dhcpd.conf
ifup eth0

# Hacer que escuche en la eth0
#cp ./isc-dhcp-server /etc/default/isc-dhcp-server
sed -i "s/INTERFACESv4=\"\"/INTERFACESv4=\"eth0\"/g" /etc/default/isc-dhcp-server

# Reiniciamos servicio dhcp
#systemctl enable isc-dhcp-server.service
systemctl restart isc-dhcp-server.service

# Poner server como DNS
cp resolv.conf /etc/resolv.conf
