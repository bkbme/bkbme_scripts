#!/bin/sh
 
#####################################################
# IPTables Firewall-Skript                          #
#                                                   #
# erzeugt mit dem IPTables-Skript-Generator auf     #
#      tobias-bauer.de - Version 0.4                #
# URL: http://www.tobias-bauer.de/iptables.html     #
#                                                   #
# Autor: Tobias Bauer                               #
# E-Mail: scripts@tobias-bauer.de                   #
#                                                   #
# Das erzeugte Skript steht unter der GNU GPL!      #
#                                                   #
# ACHTUNG! Die Benutzung des Skriptes erfolgt auf   #
# eigene Gefahr! Ich übernehme keinerlei Haftung    #
# für Schäden die durch dieses Skript entstehen!    #
#                                                   #
#####################################################
 
# iptables suchen
iptables=`which iptables`
ip6tables=`which ip6tables`

modprobe ip_conntrack_ftp
sysctl -w net/netfilter/nf_conntrack_tcp_loose=0
 
# wenn iptables nicht installiert abbrechen
test -f $iptables || exit 0
 
case "$1" in
   start)
      #
      # IPv4
      #
      
      echo "Starte Firewall ipv4..."
      # alle Regeln löschen
      $iptables -t nat -F
      $iptables -t filter -F
      $iptables -X
 
      # neue Regeln erzeugen
      $iptables -N garbage
      #$iptables -I garbage -p TCP -j LOG --log-prefix="DROP TCP-Packet: " --log-level 3
      #$iptables -I garbage -p UDP -j LOG --log-prefix="DROP UDP-Packet: " --log-level 3
      #$iptables -I garbage -p ICMP -j LOG --log-prefix="DROP ICMP-Packet: " --log-level 3
 
      # Default Policy
      $iptables -P INPUT DROP
      $iptables -P OUTPUT DROP
      $iptables -P FORWARD DROP
 
      # über Loopback alles erlauben
      $iptables -I INPUT -i lo -j ACCEPT
      $iptables -I OUTPUT -o lo -j ACCEPT
 
      #####################################################
      # ausgehende Verbindungen
      # Port 21
      $iptables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 21 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 21 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --sport 49152:65535 --dport 20 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 20 --dport 49152:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 22
      $iptables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 22 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 80
      $iptables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 80 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 443
      $iptables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 443 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 873
      $iptables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 873 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 873 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 1935
      $iptables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 1935 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 1935 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
 
      #####################################################
      # eingehende Verbindungen
      # Port 21
      $iptables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 21 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --sport 21 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 1024:65535 -m state --state NEW -j ACCEPT
      $iptables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 20 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --sport 49152:65535 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --sport 20 --dport 1024:65535 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      # Port 22
      $iptables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --sport 22 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 80
      $iptables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --sport 80 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 443
      $iptables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --sport 443 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 873
      $iptables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 873 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --sport 873 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      
      #ICMP
      $iptables -I INPUT -p icmp -j ACCEPT
      $iptables -I OUTPUT -p icmp -j ACCEPT

      # Port 53
      $iptables -I INPUT -i eth0 -p TCP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p TCP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I INPUT -i eth0 -p UDP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $iptables -I OUTPUT -o eth0 -p UDP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

      #####################################################
      # Erweiterte Sicherheitsfunktionen
      # SynFlood
      $iptables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
      $iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
      $iptables -A INPUT -f -j DROP
      $iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
      $iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
      $iptables -A INPUT -m state --state INVALID -j DROP
      
      # PortScan
      $iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
      # Ping-of-Death
      $iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
 
      #####################################################
      # bestehende Verbindungen akzeptieren
      $iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      $iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 
      #####################################################
      # Garbage übergeben wenn nicht erlaubt
      $iptables -A INPUT -m state --state NEW,INVALID -j garbage
 
      #####################################################
      # alles verbieten was bisher erlaubt war
      $iptables -A INPUT -j garbage
      $iptables -A OUTPUT -j garbage
      $iptables -A FORWARD -j garbage

      #
      # IPv6
      #
      
      echo "Starte Firewall ipv6 ..."
      # alle Regeln löschen
      $ip6tables -t filter -F
      $ip6tables -X
 
      # neue Regeln erzeugen
      $ip6tables -N garbage
      #$ip6tables -I garbage -p TCP -j LOG --log-prefix="DROP TCP-Packet: " --log-level 3
      #$ip6tables -I garbage -p UDP -j LOG --log-prefix="DROP UDP-Packet: " --log-level 3
      #$ip6tables -I garbage -p ICMPv6 -j LOG --log-prefix="DROP ICMP-Packet: " --log-level 3
 
      # Default Policy
      $ip6tables -P INPUT DROP
      $ip6tables -P OUTPUT DROP
      $ip6tables -P FORWARD DROP
 
      # über Loopback alles erlauben
      $ip6tables -I INPUT -i lo -j ACCEPT
      $ip6tables -I OUTPUT -o lo -j ACCEPT
 
      #####################################################
      # ausgehende Verbindungen
      # Port 21
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 21 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 21 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 49152:65535 --dport 20 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 20 --dport 49152:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 22
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 22 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 80
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 80 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 443
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 443 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 873
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 873 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 873 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 1935
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 1024:65535 --dport 1935 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 1935 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
 
      #####################################################
      # eingehende Verbindungen
      # Port 21
      $ip6tables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 21 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 21 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 1024:65535 -m state --state NEW -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 20 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 49152:65535 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 20 --dport 1024:65535 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      # Port 22
      $ip6tables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 22 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 22 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 80
      $ip6tables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 80 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 443
      $ip6tables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 443 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT
      # Port 443
      $ip6tables -I INPUT -i eth0 -p TCP --sport 1024:65535 --dport 873 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --sport 873 --dport 1024:65535 -m state --state ESTABLISHED,RELATED -j ACCEPT

      #ICMP
      $ip6tables -I INPUT -p icmpv6 -j ACCEPT
      $ip6tables -I OUTPUT -p icmpv6 -j ACCEPT

      # Port 53
      $ip6tables -I INPUT -i eth0 -p TCP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p TCP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I INPUT -i eth0 -p UDP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -I OUTPUT -o eth0 -p UDP --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
 
      #####################################################
      # Erweiterte Sicherheitsfunktionen
      # SynFlood
      $ip6tables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
      $ip6tables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
      $ip6tables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
      $ip6tables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
      $ip6tables -A INPUT -m state --state INVALID -j DROP
      # PortScan
      $ip6tables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
      # Ping-of-Death
      $ip6tables -A FORWARD -p icmpv6 --icmpv6-type echo-request -m limit --limit 1/s -j ACCEPT
 
      #####################################################
      # bestehende Verbindungen akzeptieren
      $ip6tables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
      $ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 
      #####################################################
      # Garbage übergeben wenn nicht erlaubt
      $ip6tables -A INPUT -m state --state NEW,INVALID -j garbage
 
      #####################################################
      # alles verbieten was bisher erlaubt war
      $ip6tables -A INPUT -j garbage
      $ip6tables -A OUTPUT -j garbage
      $ip6tables -A FORWARD -j garbage
      ;;
   stop)
      echo "Stoppe Firewall..."
      $iptables -t nat -F
      $iptables -t filter -F
      $iptables -X
      $iptables -P INPUT ACCEPT
      $iptables -P OUTPUT ACCEPT
      $iptables -P FORWARD ACCEPT

      $ip6tables -t filter -F
      $ip6tables -X
      $ip6tables -P INPUT ACCEPT
      $ip6tables -P OUTPUT ACCEPT
      $ip6tables -P FORWARD ACCEPT
      ;;
   restart|reload|force-reload)
   $0 stop
   $0 start
      ;;
   *)
      echo "Usage: /etc/init.d/firewall (start|stop)"
      exit 1
      ;;
esac
exit 0
