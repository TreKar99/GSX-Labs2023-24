#!/bin/bash

if [ "$HOSTNAME" = "server" ]; then
	cp snmp* /etc/snmp/
	/etc/init.d/snmpd restart
fi

if [ "$HOSTNAME" = "router" ]; then
	cp snmp.conf /etc/snmp/
        /etc/init.d/snmpd restart	
fi

if [ "$HOSTNAME" = "dhcp" ]; then
	cp snmp.conf /etc/snmp/
        /etc/init.d/snmpd restart
fi

