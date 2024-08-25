#!/bin/bash

function get_size() {
    if [ $1 -ge 30 ]; then
        size="4U"
    elif [ $1 -ge 10 ]; then
        size="2U"
    elif [ $1 -gt 0 ]; then
        size="1U"
    else
        size="Unkonw"
    fi
    echo $size
}

function strip() {
    echo $(echo $1 | awk '{gsub(/^\s+|\s+$/, "");print}')
}

function write_file() {
    echo -e $* >>server_size.out
}

function server_size() {
    filename=$1
    while read line; do
        ip=$line
        echo "ssh root@${ip} ..."
        result=$(ssh -o ConnectTimeout=1 -n -tt root@${ip} "df -hT | grep s2 | wc -l")
        result=$(strip $result)
        echo "disk count [${result}]"
        if [[ $result && $result != "df:" ]]; then
            dcount=$((result))
        else
            dcount=0
        fi
        size=$(get_size $dcount)
        echo "server size $size"
        write_file $ip "\t" $dcount "\t" $size
    done <$filename
}

server_size $1
