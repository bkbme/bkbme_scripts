#!/bin/bash
#Script for updating subdomain a entries -> dyndns style!

UTIL="/usr/local/psa/bin/dns"

if [ $# -ne 3 ]; then
  echo "SYNTAX: $0 <DOMAIN> <SUBDOMAIN> <NEWIP>"
  exit -1;
fi

DOMAIN="$1"
SUBDOMAIN="$2"
NEWIP="$3"

#First delete old entry
$UTIL -d $DOMAIN -a $SUBDOMAIN -ip `$UTIL --info $DOMAIN | grep $SUBDOMAIN |  cut -d' ' -f 4` 
RV=$?

if [ $RV -ne 0 ]; then
  exit $RV;
fi

#Then add the new entry
$UTIL -a $DOMAIN -a $SUBDOMAIN -ip $NEWIP

if [ $RV -ne 0 ]; then
  exit $RV;
fi

exit 0;
