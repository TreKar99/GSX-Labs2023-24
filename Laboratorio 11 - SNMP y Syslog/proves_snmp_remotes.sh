#!/bin/bash

# Pruebas Locales
snmpget -v 2c -c public 198.18.124.1 system.sysName.0 > sortida_snmp_remota_prac5.txt
snmpwalk -v 2c -c public 198.18.124.1 system >> sortida_snmp_remota_prac5.txt
snmpwalk -v 2c -c public 198.18.124.1 hrSystem >> sortida_snmp_remota_prac5.txt
#snmptable -v 2c -c cilbup 198.18.124.1 UCD-SNMP-MIB::prTable >> sortida_snmp_remota_prac5.txt
#snmptable -v 2c -c cilbup 198.18.124.1 ucdavis.dskTable >> sortida_snmp_remota_prac5.txt
#snmptable -v 2c -c cilbup 198.18.124.1 ucdavis.laTable >> sortida_snmp_remota_prac5.txt

# Pruebas USM
snmpget -v3 -u gsxViewer -l authNoPriv -a SHA -A aut48013892N 198.18.124.1 system.sysDescr.0 >> sortida_snmp_remota_prac5.txt
snmpget -v3 -u gsxAdmin -l authPriv -a SHA -A aut48013892N -x DES -X sec29831084 198.18.124.1 system.sysDescr.0 >> sortida_snmp_remota_prac5.txt
