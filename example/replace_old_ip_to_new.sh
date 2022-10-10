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
      local LightCyan="$(
        tput bold
        tput setaf 6
      )"
      _LOG_LEVEL=DEBUG log "$LightCyan" "$@"
    fi
}

step()
{
    let gindex=gindex+1
    local LightBlue="$(
      tput bold
      tput setaf 4
    )"
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
    local Yellow="$(
      tput bold
      tput setaf 3
    )"
    _LOG_LEVEL="  WARN" log "${Yellow}" "$@"
}

err()
{
    # 设置前景色 red
    local Red="$(tput setaf 1)"
    _LOG_LEVEL=" ERROR" log "${Red}" "$@"
}

do_replace_all_node()
{
    info "replace $1 to $2 in all-node.md"

    if grep "$1 " ./all-node.md; then
        sed -i '' "s/$1 /$2 /g" ./all-node.md
        grep "$2 " ./all-node.md && ok 'all-node replace successfully'
    else
        err "not found $1 in all-node.md"
    fi
}

do_replace_2copy_hosts()
{
    info "replace $1 to $2 in baishan-2copy"

    if grep "$1:" ./baishan-2copy/indexed_hosts.yaml; then
        sed -i '' "s/$1:/$2:/g" ./baishan-2copy/indexed_hosts.yaml
        grep "$2:" ./baishan-2copy/indexed_hosts.yaml && ok 'indexed_hosts replace successfully'
    else
        err "not found $1 in baishan-2copy/indexed_hosts.yaml"
    fi

    if grep "$1$" ./baishan-2copy/hosts.yaml; then
        sed -i '' "s/$1$/$2/g" ./baishan-2copy/hosts.yaml
        grep "$2$" ./baishan-2copy/hosts.yaml && ok 'hosts replace successfully'
    else
        err "not found $1 in baishan-2copy/hosts.yaml"
    fi
}

do_replace_3copy_hosts()
{
    info "replace $1 to $2 in baishan-3copy"

    if grep "$1:" ./baishan-3copy/indexed_hosts.yaml; then
        sed -i '' "s/$1:/$2:/g" ./baishan-3copy/indexed_hosts.yaml
        grep "$2:" ./baishan-3copy/indexed_hosts.yaml && ok 'indexed_hosts replace successfully'
    else
        err "not found $1 in baishan-3copy/indexed_hosts.yaml"
    fi

    if grep "$1$" ./baishan-3copy/hosts.yaml; then
        sed -i '' "s/$1$/$2/g" ./baishan-3copy/hosts.yaml
        grep "$2$" ./baishan-3copy/hosts.yaml && ok 'hosts replace successfully'
    else
        err "not found $1 in baishan-3copy/hosts.yaml"
    fi
}

do_replace_old_to_new()
{
    while read line; do
        arr=($(echo $line | tr ',' ' '))
        old_ip=${arr[0]}
        new_ip=${arr[1]}
        do_replace_3copy_hosts $old_ip $new_ip
        do_replace_all_node $old_ip $new_ip
        do_replace_2copy_hosts $old_ip $new_ip
    done <./old_new_ip
}

do_replace_old_to_new