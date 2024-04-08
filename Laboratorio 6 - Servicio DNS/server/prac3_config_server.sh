# Asignar ultima IP disponible del rango
ifdown eth0
cp interfaces /etc/network/interfaces
ifup eth0

# Permitir acceso root ssh
cp sshd_config /etc/ssh/sshd_config

# DNS = router
cp resolv.conf.extern.dns /etc/resolv.conf

# Comprobar si paquetes dns instalados
#if [ -z "$(apt list --installed 2</dev/null | grep -w bind9 2</dev/null)" ];
#then
	# Conflicto (no crea /etc/bind), instalar sin comprobación.
	apt install bind9 -y;
#fi

if [ -z "$(apt list --installed 2</dev/null | grep -w bind9-doc 2</dev/null)" ];
then
        apt install bind9-doc -y;
fi

if [ -z "$(apt list --installed 2</dev/null | grep -w dnsutils 2</dev/null)" ];
then
        apt install dnsutils -y;
fi

# Configurem els servidor DNS perque sols atengui peticions IPv4
sed -i "s/OPTIONS=\"-u bind\"/OPTIONS=\"-u bind -4\"/g" /etc/default/named

# Copiem fichers de configuració DNS
for file in $(ls | grep -E 'named.'); do
	chmod --reference=/etc/bind/$file $file;
	cp $file /etc/bind;
done

# Copiarem els fitxers de zona a /var/cache/bind/
for file in $(ls *db*); do
	#chmod --reference=/var/cache/bind $file;
	cp *db* /var/cache/bind
	chmod --reference=/etc/bind /var/cache/bind/$file;
done

# Reiniciar el servicio como daemon
systemctl restart bind9

# Modifiquem el fitxer /etc/resodlv.conf posant-hi com a nameserver el localhost i el search dels nostres dominis
cp resolv.conf /etc/resolv.conf
