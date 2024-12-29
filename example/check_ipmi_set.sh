#!/bin/bash

SHLIB_LOG_VERBOSE=1
SHLIB_LOG_FORMAT='    [$level] $title $mes'

die()
{
    err "$@" >&2
    exit 1
}

log()
{
    local color="$1"
    local title="$2"
    local level="$_LOG_LEVEL"
    shift
    shift

    local mes="$@"
    local NC="$(tput sgr0)"

    if [ -t 1 ]; then
        title="${color}${title}${NC}"
        level="${color}${level}${NC}"
    fi
    eval "echo \"$SHLIB_LOG_FORMAT\""
}

dd()
{
    debug "$@"
}

debug()
{
    if [ ".$SHLIB_LOG_VERBOSE" = ".1" ]; then
        local LightCyan="$(tput bold ; tput setaf 6)"
        _LOG_LEVEL=DEBUG log "$LightCyan" "$@"
    fi
}

step()
{
    let gindex=gindex+1
    local LightBlue="$(tput bold; tput setaf 4)"
    _LOG_LEVEL="Step $gindex" log "$LightBlue" "$@"
}

info()
{
    local Brown="$(tput setaf 3)"
    _LOG_LEVEL="  INFO" log "$Brown" "$@"
}

ok()
{
    local Green="$(tput setaf 2)"
    _LOG_LEVEL="    OK" log "${Green}" "$@"
}

warn()
{
    local Yellow="$(tput bold; tput setaf 3)"
    _LOG_LEVEL="  WARN" log "${Yellow}" "$@"
}

err() {
    local Red="$(tput setaf 1)"
    _LOG_LEVEL=" ERROR" log "${Red}" "$@"
}


check_ipmi()
{
    info "setup ipmi host_ip $inn_ip idc_name $idc_name"

    if [[ "${idc_name}" == '.shijiazhuang.xunjie' || "${idc_name}" == '.ningbo.yinzhou' ]]; then
        ipmi_ip=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_ip=sprintf("%d.%d.%d.%d",arr[1],arr[2],arr[3]+32,arr[4]);print ipmi_ip}')
    elif [[ "${idc_name}" == '.anhui.huinan' || "${idc_name}" == '.shijiazhuang.changshan' || "${idc_name}" == '.shijiazhuang.xiangyang' ]]; then
        ipmi_ip=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_ip=sprintf("%d.%d.%d.%d",arr[1],arr[2],arr[3]+128,arr[4]);print ipmi_ip}')
    else
        ipmi_ip=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_ip=sprintf("%d.%d.%d.%d",arr[1],arr[2],arr[3]+32,arr[4]);print ipmi_ip}')
    fi

    info "check ipmi ip_addr $ipmi_ip"

    ipmitool -H $ipmi_ip -I lanplus -U root -P $ipmi_passwd power status ||  die "check ipmi set error"

    ok "ipmi setup successfully"
}


inn_ips=$(ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'\
          | grep -e "^192\.168" -e "^172\.[1-3].\.*" -e "^10\.")

for ip in $inn_ips; do

    ip_info=$(ifconfig | grep $ip -B 1)
    ip_dev=$(echo $ip_info | awk -F: '{print $1}')

    if [ $ip_dev != 'docker0' ];then
        inn_ip=$ip
        inn_dev=$ip_dev
    fi

done

if [[ "$inn_ip" =~ ^10\.101.* ]]; then
    idc_name='.shijiazhuang.xiangyang'
elif [[ "$inn_ip" =~ ^10\.102.* ]]; then
    idc_name='.taizhou.yidong'
elif [[ "$inn_ip" =~ ^10\.103.* ]]; then
    idc_name='.shijiazhuang.changshan'
elif [[ "$inn_ip" =~ ^10\.104.* ]]; then
    idc_name='.ningbo.yinzhou'
else
    idc_name='unkown'
fi

ipmi_passwd=$password

ok "start check"

check_ipmi

ok "check finish"

# 功能
# 1、设置 ipmi 地址
# 2、设置 ipmi 密码
