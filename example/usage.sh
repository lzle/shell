#!/bin/bash

usage()
{
    cat <<-END

    usage: $0  <passwd>

        <passwd>               static value, contact s2 team if you forget it
    eg.  sh $0 xxx, file_url
END
}

login_passwd=$1
if [ -z "$login_passwd" ]; then
    usage
    echo "missing passwd"
    exit 1
fi