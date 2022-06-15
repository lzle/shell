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
    # 设置前景色 red
    local Red="$(tput setaf 1)"
    _LOG_LEVEL=" ERROR" log "${Red}" "$@"
}


setup_ipmi()
{
    info "setup ipmi"
    channel_id=1

    if [[ "${idc_name}" == '.shijiazhuang.xunjie' || "${idc_name}" == '.ningbo.yinzhou' ]]; then
        ipmi_ip=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_ip=sprintf("%d.%d.%d.%d",arr[1],arr[2],arr[3]+32,arr[4]);print ipmi_ip}')
        ipmi_netmask='255.255.224.0'
        ipmi_gateway=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_gateway=sprintf("%d.%d.%d.%d",arr[1],arr[2],32,1);print ipmi_gateway}')
    elif [[ "${idc_name}" == '.taizhou.yidong' || "${idc_name}" == '.shijiazhuang.changshan' ]]; then
        ipmi_ip=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_ip=sprintf("%d.%d.%d.%d",arr[1],arr[2],arr[3]+128,arr[4]);print ipmi_ip}')
        ipmi_netmask='255.255.192.0'
        ipmi_gateway=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_gateway=sprintf("%d.%d.%d.%d",arr[1],arr[2],128,1);print ipmi_gateway}')
    else
        ipmi_ip=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_ip=sprintf("%d.%d.%d.%d",arr[1],arr[2],arr[3]+32,arr[4]);print ipmi_ip}')
        ipmi_netmask='255.255.224.0'
        ipmi_gateway=$(echo "$inn_ip" | awk '{split($0,arr,".");ipmi_gateway=sprintf("%d.%d.%d.%d",arr[1],arr[2],32,1);print ipmi_gateway}')
    fi

    ipmitool -I open sensor  >/dev/null 2>&1 || die "open sensor error"
    ipmitool -I open lan set "$channel_id" ipsrc static  >/dev/null 2>&1 || die "set ipsrc static error"
#    ipmitool -I open lan set "$channel_id" user >/dev/null 2>&1 || die "set $channel_id user error"
    ipmitool -I open lan set "$channel_id" access on  >/dev/null 2>&1 || die "set $channel_id access on error"

    ipmitool lan set "$channel_id" ipaddr "$ipmi_ip" >/dev/null 2>&1 || die "set ipmi ip error"
    ipmitool lan set "$channel_id" netmask "$ipmi_netmask" >/dev/null 2>&1 || die "set netmask error"
    ipmitool lan set "$channel_id" defgw ipaddr "$ipmi_gateway" >/dev/null 2>&1 || die "set defgw error"

    ping -c 3 -i 0.2 -W 3 "$ipmi_ip" >/dev/null 2>&1  || die "ipmi ip $ipmi_ip is unreachable"

    ipmi_root_id=$(ipmitool user list 1 2>/dev/null | grep root | awk '{print $1}')

    if [ -z "$ipmi_root_id" ];then
        ipmi_root_id=2
    fi

    ipmitool channel setaccess "$channel_id" "$ipmi_root_id" callin=on ipmi=on link=on privilege=4 \
                                >/dev/null 2>&1 || die "set ipmi channel access error"
    ipmitool -I open user set name "$ipmi_root_id" root >/dev/null 2>&1 || die "set ipmi root name error"
    ipmitool user set password "$ipmi_root_id" "$ipmi_passwd" >/dev/null 2>&1 || die "set ipmi root passwd error"

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
    idc_name='.shijiazhuang.xunjie'
elif [[ "$inn_ip" =~ ^10\.102.* ]]; then
    idc_name='.taizhou.yidong'
elif [[ "$inn_ip" =~ ^10\.103.* ]]; then
    idc_name='.shijiazhuang.changshan'
elif [[ "$inn_ip" =~ ^10\.104.* ]]; then
    idc_name='.ningbo.yinzhou'
else
    idc_name='unkown'
fi

ipmi_passwd='bsy@2022#bs8'


ok "start setup items"

setup_ipmi

ok "setup all items successfully"



