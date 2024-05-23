#!/bin/bash

# Si no se ejecuta con sudo, salir
if [[ $(whoami) != "root" ]]; then
  echo "Este script debe ejecutarse con sudo."
  exit 1
fi

# Crear els enllaços
for node in {1..4}; do
	ip link add link${node}_veth1 type veth peer name link${node}_veth2
done

# Assignar-los als contenidors
for node in {1..4}; do
	pid=$(docker inspect --format '{{.State.Pid}}' R$node)
	ip link set netns $pid dev link${node}_veth1
	nsenter -t $pid -n ip addr add 10.124.$node.1/30 dev link${node}_veth1
	nsenter -t $pid -n ip link set dev link${node}_veth1 up
done

# Assignar IPs
# R1
pid=$(docker inspect --format '{{.State.Pid}}' R1)
ip link set netns $pid dev link4_veth2
nsenter -t $pid -n ip addr add 10.124.4.2/30 dev link4_veth2
nsenter -t $pid -n ip link set dev link4_veth2 up

# R2
pid=$(docker inspect --format '{{.State.Pid}}' R2)
ip link set netns $pid dev link1_veth2
nsenter -t $pid -n ip addr add 10.124.1.2/30 dev link1_veth2
nsenter -t $pid -n ip link set dev link1_veth2 up

# R3
pid=$(docker inspect --format '{{.State.Pid}}' R3)
ip link set netns $pid dev link2_veth2
nsenter -t $pid -n ip addr add 10.124.2.2/30 dev link2_veth2
nsenter -t $pid -n ip link set dev link2_veth2 up

# R4
pid=$(docker inspect --format '{{.State.Pid}}' R4)
ip link set netns $pid dev link3_veth2
nsenter -t $pid -n ip addr add 10.124.3.2/30 dev link3_veth2
nsenter -t $pid -n ip link set dev link3_veth2 up
