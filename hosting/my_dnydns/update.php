<?php
/* DDNS Server
 * Copyright 2006, Steve Blinch
 * http://code.blitzaffe.com
 * ============================================================================
 *
 * This script is free software; you can redistribute it and/or modify it under the
 * terms of the GNU General Public License as published by the Free Software
 * Foundation; either version 2 of the License, or (at your option) any later
 * version.
 *
 * This script is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *	
 * You should have received a copy of the GNU General Public License along
 * with this script; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

die('Fail');

function getData($getParamName) 
{
  $retVal="";
  if(isset($_GET[$getParamName])) {
    $retVal=htmlspecialchars($_GET[$getParamName]);
  }

  return $retVal;
}

function logData($data)
{
  $logFile = fopen('log.txt', 'a+');
  $date = getdate();
  fwrite($logFile, '|'.$date['year'].'-'.$date['mon'].'-'.$date['mday'].'--'.$date['hours'].':'.$date['minutes'].':'.$date['seconds'].'| '.$data."\n");
  fclose($logFile);
}


if(!isset($_SERVER['PHP_AUTH_USER']))
{
  header('WWW-Authenticate: Basic realm="ddupdate"');
  header('HTTP/1.0 401 Unauthorized');
}

$hostname = strtolower(getData("hostname"));
$myip     = getData("myip"); 
$username = htmlspecialchars($_SERVER['PHP_AUTH_USER']);
$password = htmlspecialchars($_SERVER['PHP_AUTH_PW']);
$remoteip = htmlspecialchars($_SERVER['REMOTE_ADDR']);

$hostToks = preg_split("/\./", $hostname);
if (!preg_match('/^[a-z0-9\.-]+$/i',$hostname) || count($hostToks) != 3) die('notfqdn');
if (!preg_match('/^((?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/i',$myip)) die('dnserr');

$cmd=$hostToks[1].'.'.$hostToks[2].':'.$hostToks[0].':'.$myip.";\n";

$cmdFifo = fopen("ddfifo", 'wr');
fwrite($cmdFifo, $cmd);
fclose($cmdFifo);

$rvFifo = fopen("ddfifo2", 'r');
$retVal = fread($rvFifo, 1);
fclose($rvFifo);

logData('Request from ip ('.$remoteip.') hostname ('.$hostname.') User ('.$username.') Password ('.$password.') requested ip ('.$myip.')');
logData('RetVal is('.$retVal.')');


print_r($retVal);

if($retVal == '0') {
  print('good');
} else {
  printf('dnserr');
}

/*
print('Hostname: '.$hostname.'<p>');
print('Ip: '.$myip.'<p>');
print('username: '.$username.'<p>');
print('password: '.$password.'<p>');
*/
?>

