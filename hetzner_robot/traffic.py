# -*- coding: utf-8 -*-
"""
Created on Fri Dec 26 17:58:23 2014

@author: bkbme

This script uses the Hetzner webservice api to receive traffic infos of the rented dedicated servers.
"""

import httplib
import urllib
import base64
import json
import datetime

user='<username>'
password='<password>'
host='robot-ws.your-server.de'

def requestTrafficUsed(typeS, fromS, to, ip):
  auth = base64.encodestring('%s:%s' % (user, password)).replace('\n', '')
  
  headers = {"Content-type": 'application/x-www-form-urlencoded', \
             'Accept': 'text/plain', \
             'Authorization': 'Basic %s' % auth}
  paramsMap = {'type': typeS, \
               'from': fromS, \
               'to': to}
  if ':' in ip:
    paramsMap['subnet[]'] = ip
    ip += '/64'
  else:
    paramsMap['ip[]'] = ip
  
  params = urllib.urlencode(paramsMap)
                             
  con = httplib.HTTPSConnection(host)
  con.request("POST", "/traffic", params, headers)
  
  res =con.getresponse()
  data = res.read()
  
  #print res, data
  
  trafficGb = 0
  if res.status == 200:    
    dataStruct = json.loads(data)
    if len(dataStruct['traffic']['data']) > 0:
      trafficGb = float(dataStruct['traffic']['data'][ip]['sum'])
    else:
      trafficGb = 0.0
  return trafficGb


#Put server ipv4 address here
ipv4Address = '888.888.888.888'
#Put server ipv6 subnet here
ipv6Address = '2a01:zz::'
    
today = datetime.datetime.now()
trafficToday =  requestTrafficUsed('day', '%d-%d-%dT00' % (today.year, today.month, today.day), \
                                          '%d-%d-%dT24' % (today.year, today.month, today.day), \
                                          ipv4Address)
                         
trafficDec =  requestTrafficUsed('month', '2014-12-01', \
                                          '2014-12-31', \
                                          ipv4Address)
                                       
trafficJan =  requestTrafficUsed('month', '2015-01-01', \
                                          '2015-01-31', \
                                          ipv4Address)
                                       
traffic6Today =  requestTrafficUsed('day', '%d-%d-%dT00' % (today.year, today.month, today.day), \
                                          '%d-%d-%dT24' % (today.year, today.month, today.day), \
                                           ipv6Address)
     
                         
traffic6Dec =  requestTrafficUsed('month', '2014-12-01', \
                                           '2014-12-31', \
                                           ipv6Address)
                                       
traffic6Jan =  requestTrafficUsed('month', '2015-01-01', \
                                          '2015-01-31', \
                                           ipv6Address)
                                  
                                  
totalTrafficV4 = trafficToday + trafficDec + trafficJan
totalTrafficV6 = traffic6Today + traffic6Dec + traffic6Jan
totalTrafficToday = trafficToday + traffic6Today
totalTraffic = totalTrafficV4 + totalTrafficV6

print totalTrafficV4

f = open('/srv/html/totalTrafficV4.txt', 'w')
f.write(str(totalTrafficV4))
f.close()
f = open('/srv/html/totalTrafficV6.txt', 'w')
f.write(str(totalTrafficV6))
f.close()
