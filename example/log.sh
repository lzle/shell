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