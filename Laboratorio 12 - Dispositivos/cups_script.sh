#!/bin/bash

PATH=$PATH:/usr/sbin/

# Comprobamos que se esté ejecutando en modo root
if [ $EUID -ne 0 ]; then
	echo " El script debe ejecutarse en modo root." >&2
	exit 1
fi

# Verificar si el paquet CUPS està instal·lat
if ! dpkg -l | grep -q cups; then
  echo "Instal·lant paquetes CUPS..."
  sudo apt install cups cups-pdf -y
fi

# Crear la impressora virtual lpVirtual
lpadmin -p lpVirtual -D "Impresora PDF Virtual" -L "Ninguna" -v cups-pdf:/ -m lsb/usr/cups-pdf/CUPS-PDF_opt.ppd

# Configurar lpVirtual com a impressora per defecte
lpadmin -d lpvirtual

# Confiturar lpVirtual per acceptar peticions

echo "La impressora virtual lpVirtual s'ha configurat correctament."
echo "Els documents s'imprimiran a PDF i es guardaran a /home/$USER/PDF."
echo "Ara pots enviar documents a imprimir amb la comanda 'lp'."
