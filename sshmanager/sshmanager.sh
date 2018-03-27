#!/bin/bash

: 'This script is to provide a convient way for connecting ssh
'
unset http_proxy
unset https_proxy
conf=/etc/sshmanager.hosts
pass_prefix=sshmanager

function ls_server()
{
        #If configuration file doesn't exist, create one
       if [ ! -e $conf ]; then
	   echo -e "You haven't the config file $.conf!"
	   echo -e "Do you want to make one?"
	   select choice in Yes No; do
			     case $choice in
				 Yes )
				     sudo touch $conf;
				     sudo chown $USER: $conf
				     break;;
				 No ) exit;;
				 *  ) echo -e "You must specify the number option";
				      continue;;
			     esac;
	   done;
       fi;
       servers=$(cat $conf)
       if [ -z "$servers" ];then
	   echo -e "no servers available!"
	   exit;
       else
	   echo -e "Servers available:"
	   local IFS=';'
	   servers=$(echo $servers |  grep -oP '\w+(?=:)')
	   unset IFS
	   count=0
	   for server in $servers; do
	       count=$((count+1))
	       echo '['$count']' $server
	   done;
       fi;
}

function add_server()
{
       echo -e "Adding $1 server:"
       read -p "user:" user
       read -p "hostname:" hostname
       echo "$1:$user@$hostname" >> /etc/sshmanager.hosts
       pass insert $pass_prefix/$1
       echo -e "$1 is added."
}

function connect_server()
{

    # Check if there are some servers
	servers=$(cat $conf)
	if [ -z "$servers" ];then
	    echo -e "no servers available!";
	    echo -e "Please use sshmanager add/-a to add a server first!";
	    exit;
	else
	    if [[ -z "${servers##*$1*}" ]];then
		echo -e "Connecting to $1 server ..."
		#Get the conn info servername:user@hostname
		conn=$(echo $servers | awk  "{ if (match(\$0,/$1:[a-zA-Z]+@[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/,m)) { print m[0];}}")
		#get the info for the ssh connection user@hostname
		sshconn=${conn##*:}
		#connect
		sshpass -p $(pass show $pass_prefix/$1) ssh  $sshconn
	    else
		echo -e "$1 server not availabel!"
		echo -e "servers available in:"
		cat $conf
	    fi;
	fi;
}

function delete_server(){
    # Check if there are some servers
    servers=$(cat $conf)
    if [ -z $1 ];then
	echo -e "You must specify a server to be deleted!"
	ls_server
	exit;
    fi;
    if [ -z "$servers" ];then
	echo -e "no servers available!";
	echo -e "Please use sshmanager add/-a to add a server first!";
	exit;
    else
	if [[ -z "${servers##*$1*}" ]];then
	    echo -e "Cleaning $1 server's info..."
	    sed  -e "/$1:.\+@[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/d" $conf>$conf
	    pass rm $pass/$1
	    echo -e "Server $1 has deleted."
	else
	    echo -e "$1 server not availabel!"
	    echo -e "servers available in:"
	    echo $servers
	fi;
    fi;
}
function sshmanager()
{
    if (( $# <= 0 ));then
	sshmanager ls
	exit;
    fi;
    # List available ssh server(sshmanager -l/ls)
    if [ $1 == "ls"  ] || [ $1 == "-l" ]; then
	ls_server
    fi;
   # Add a new ssh server (sshmanager -a/add)
    if [ $1 == "add" ] || [ $1 == "-a" ]; then
	add_server $2
    fi;

    # Connect a ssh server (sshmanager -c/connect)
    if [ $1 == "connect" ] || [ $1 == "-c" ]; then
	connect_server $2
    fi;
    # Remove a ssh server
     if [ $1 == "rm" ] || [ $1 == "-d" ]; then
	delete_server $2
    fi;
    
}

sshmanager $* 



