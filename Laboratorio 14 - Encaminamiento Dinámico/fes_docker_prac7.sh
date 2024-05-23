#!/bin/bash
IMAGE="gsx:prac7"
OPCIONS="-itd --rm --privileged"

# Fer build de la imatge
docker build -t $IMAGE -f dockerfile_gsx_prac7 .

docker run $OPCIONS --hostname router1 --name R1 $IMAGE

# A excepció del R1, els docker run s'han de fer sense networks
for node in {2..4}; do
	docker run $OPCIONS --hostname router$node --network=none --name R$node $IMAGE
done

# Crear networks
echo "WARNING: necesario ser superuser"
echo "--> Creación de networks"
sudo ./networks_prac7.sh

# Executar la configuració del protocol RIP
for node in {1..4}; do
	docker exec R$node /root/prac7_config_rip.sh
done
