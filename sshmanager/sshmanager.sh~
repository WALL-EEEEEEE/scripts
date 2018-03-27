#!/bin/bash
conf=/etc/sshmanager.hosts
pass_prefix=sshmanager

function sshmanager()
{
    # List available ssh server(sshmanager -l/ls)
    if [ $1 == "ls"  ] || [ $1 == "-l" ]; then
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
	   echo $servers
       fi;

    fi;
    # Add a new ssh server (sshmanager -a/add)
    if [ $1 == "add" ] || [ $1 == "-a" ]; then
       echo -e "Adding $2 server:"
       read -p "user:" user
       read -p "hostname:" hostname
       echo "$2:$user@$hostname" >> /etc/sshmanager.hosts
       pass insert $pass_prefix/$2
       echo -e "$2 is added."
    fi;

    # Connect a ssh server (sshmanager -c/connect)
    if [ $1 == "connect" ] || [ $1 == "-c" ]; then
    # Check if there are some servers
	servers=$(cat $conf)
	if [ -z "$servers" ];then
	    echo -e "no servers available!";
	    echo -e "Please use sshmanager add/-a to add a server first!";
	    exit;
	else
	    if [[ -z "${servers##*$2*}" ]];then
		echo -e "Connecting to $2 server ..."
		#Get the conn info servername:user@hostname
		conn=$(echo $servers | awk  "{ if (match(\$0,/$2:.*/,m)) { print m[0];}}")
		#get the info for the ssh connection user@hostname
		sshconn=${conn##*:}
		#connect
		sshpass -p $(pass show $pass_prefix/$2) ssh  $sshconn
	    else
		echo -e "$2 server not availabel!"
		echo -e "servers available in:"
		cat $conf
	    fi;
	fi;
    fi;
    # Remove a ssh server
     if [ $1 == "rm" ] || [ $1 == "-d" ]; then
    # Check if there are some servers
	servers=$(cat $conf)
	if [ -z $2 ];then
	    echo -e "You must specify a server to be deleted!"
	    echo -e "servers available in:"
	    echo -e $servers
	    exit;
	fi;
	if [ -z "$servers" ];then
	    echo -e "no servers available!";
	    echo -e "Please use sshmanager add/-a to add a server first!";
	    exit;
	else
	    if [[ -z "${servers##*$2*}" ]];then
		echo -e "Cleaning $2 server's info..."
		sed  -e "/$2:.\+@[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/d" $conf>$conf
		pass rm $pass/$2
		echo -e "Server $2 has deleted."
	    else
		echo -e "$2 server not availabel!"
		echo -e "servers available in:"
		echo $servers
	    fi;
	fi;
    fi;
    
}

sshmanager $* 



