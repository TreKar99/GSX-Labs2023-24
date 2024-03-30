# Asignar ultima IP disponible del rango
cp interfaces /etc/network/interfaces
ifdown eth0 2</dev/null && ifup eth0 2</dev/null

# Añadir router a /etc/hosts
cp hosts /etc/hosts

# Permitir acceso root ssh
cp sshd_config /etc/ssh/sshd_config

# DNS = router
cp resolv.conf /etc/resolv.conf
