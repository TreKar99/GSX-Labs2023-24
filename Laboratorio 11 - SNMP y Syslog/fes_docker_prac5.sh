#!/bin/bash

IMAGE="gsx:prac5"
OPCIONS="-itd --rm --cap-add=NET_ADMIN"
# --cap-add=SYS_ADMIN

# Posar a milax al docker com grup actiu
#newgrp docker

# Fer build de la imatge
docker build -t $IMAGE -f dockerfile_gsx_prac5 .

# Fer 3 xarxes ISP, DMZ, INTRANET
if [ -z "$(docker network ls | grep ISP)" ]; then
	docker network create --driver=bridge --subnet=10.0.2.16/30 ISP
fi

if [ -z "$(docker network ls | grep DMZ)" ]; then
	docker network create --driver=bridge --subnet=198.18.124.0/28 --gateway=198.18.124.2 DMZ
fi

if [ -z "$(docker network ls | grep INTRANET)" ]; then
	docker network create --driver=bridge --subnet=172.24.124.0/25 --gateway=172.24.124.2 INTRANET
fi

# Run de 3 contenidors
# Després de cada comanda docker de creació, abans de prosseguir
# Comprovar que l'objecte existeix, és a dir, que s'ha creat.

#if [[ "$(docker container ls | grep Router)" ]]; then
#	docker container rm Router	
docker run $OPCIONS --hostname router --network=ISP --name Router --mount type=bind,ro,src=$PWD/practica5,dst=/root/prac5 $IMAGE 2</dev/null
#fi

if [ -z "$(docker container ls | grep Router)" ]; then
	echo "ERROR: Contenedor Router no se ha creado... Exiting"
	exit 1
fi

docker run $OPCIONS --hostname server --network=DMZ --name Server --mount type=bind,src=$PWD/practica5,dst=/root/prac5 $IMAGE 2</dev/null

if [ -z "$(docker container ls | grep Server)" ]; then
        echo "ERROR: Contenedor Server no se ha creado... Exiting"
        exit 2
fi

docker run $OPCIONS --hostname dhcp --network=INTRANET --name DHCP --mount type=bind,ro,src=$PWD/practica5,dst=/root/prac5 $IMAGE 2</dev/null

if [ -z "$(docker container ls | grep DHCP)" ]; then
        echo "ERROR: Contenedor DHCP no se ha creado... Exiting"
        exit 3
fi



