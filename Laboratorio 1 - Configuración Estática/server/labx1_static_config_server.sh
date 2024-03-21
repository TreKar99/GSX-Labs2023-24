# Asignar ultima IP disponible del rango
cp interfaces /etc/network/interfaces
ifup eth0

# Añadir router a /etc/hosts
cp hosts /etc/hosts

# Permitir acceso root ssh
cp sshd_config /etc/ssh/sshd_config
