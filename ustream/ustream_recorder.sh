#!/bin/bash
#Use rtmpdump to record stuff on ustream.
#set -x

#Check for the right parameters
if [ $# -ne 2 ]; then
  echo "SYNTAX: $0 <USTREAMURL> <DESTFILE>"
  exit -1;
fi

#Get the channelid from the channel page.
num=`wget -qO- "$1" | grep "cid: " | cut -d"'" -f 6`

#Get the rtmp url by parsing the amf file.
url=`wget -qO- "cdngw.ustream.tv/Viewer/getStream/1/$num.amf" | grep -a "rtmp://" | sed 's/.*rtmp:\/\/flash/rtmp:\/\/flash/' | sed 's/$num.*/$num/'`

#If there is no live stream running, the url will be emtpy and we want
#to abort.
if [ ${#url} -lt 1 ]; then
  exit -1
fi

#Finally run rtmpdump and dump it.
#You can also pipe it right into mplayer and watch it live without crappy 
#Flash stuff!
rtmpdump -q -v -r $url -a ustreamVideo/$num -f LNX 10,0,45,2 -y streams/live > $2
