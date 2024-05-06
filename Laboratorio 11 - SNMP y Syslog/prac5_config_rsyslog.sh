#!/bin/bash


if [ "$HOSTNAME" = "server" ]; then
	sed -i "s/\#module(load=\"imudp\")/module(load=\"imudp\")/g" /etc/rsyslog.conf
        sed -i "s/\#input(type=\"imudp\" port=\"514\")/input(type=\"imudp\" port=\"514\")/g" /etc/rsyslog.conf
        sed -i "s/\module(load=\"imklog\")/#module(load=\"imklog\")/g" /etc/rsyslog.conf

	cp 10-remot.conf /etc/rsyslog.d/10-remot.conf
	service rsyslog restart
fi

if [ "$HOSTNAME" = "router" ]; then
	echo 'user.* @198.18.124.1:514' > /etc/rsyslog.d/90-remot.conf 
        sed -i "s/\module(load=\"imklog\")/#module(load=\"imklog\")/g" /etc/rsyslog.conf
	service rsyslog restart
fi

if [ "$HOSTNAME" = "dhcp" ]; then
	echo 'user.* @198.18.124.1:514' > /etc/rsyslog.d/90-remot.conf 
        sed -i "s/\module(load=\"imklog\")/#module(load=\"imklog\")/g" /etc/rsyslog.conf
	service rsyslog restart
fi

