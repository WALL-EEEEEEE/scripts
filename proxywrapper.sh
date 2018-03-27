#!/bin/bash

# A wrapper of proxy for terminal command
function usage() {
    bname=$(basename $1)
    fname=${bname%.*}
    printf " %s  Usage:   %s command \n" $fname $fname 
}
function proxywrapper() {
    if [  -z $1 ];then
        usage $0
    fi;
    export http_proxy="127.0.0.1:8118"
    export https_proxy="127.0.0.1:8118"
    echo "${@:1}"
    eval ${@:1}
    unset http_proxy
    unset https_proxy
}
proxywrapper $*
