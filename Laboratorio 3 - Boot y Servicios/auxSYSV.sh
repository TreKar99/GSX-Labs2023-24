#!/bin/bash

# Si no se ejecuta con sudo, salir
if [[ $(whoami) != "root" ]]; then
  echo "Este script debe ejecutarse con sudo."
  exit 1
fi

cp /home/milax/consultad /etc/init.d/consultad

# Hacerlo ejecutable
chmod +x /etc/init.d/consultad

# Registrar el servicio
ln -s /etc/init.d/consultad /etc/rc5.d/S99consultad
