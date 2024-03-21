#!/bin/bash

# Si no se ejecuta con sudo, salir
if [[ $(whoami) != "root" ]]; then
  echo "Este script debe ejecutarse con sudo."
  exit 1
fi


cp consulta.service /etc/systemd/system/consulta.service

chmod 644 /etc/systemd/system/consulta.service
