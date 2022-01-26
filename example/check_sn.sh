#!/bin/sh

#$ cat sn_ip_list
#F6056W2  10.104.21.34
#F9D36W2  10.104.21.36
#F8896W2  10.104.21.37
#F9D76W2  10.104.21.38


function check_sn()
{
    info "check sn ip"
    while read line; do
        array=($(echo $line))
        exp_sn=${array[0]}
        ip=${array[1]}
        act_sn=$(ssh -n root@$ip -o ConnectTimeout=3  -o StrictHostKeychecking=no dmidecode -t 1 \
                            | grep 'Serial Number' 2>&1 | awk -F': ' '{print $2}')
        if [[ "$act_sn" == "$exp_sn" ]]; then
            ok "check sn ok"
        else
            err "check sn failed!!! exp_sn: $exp_sn, act_sn: $act_sn"
        fi
    done < sn_ip_list
}

check_sn
