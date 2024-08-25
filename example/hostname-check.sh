(
    INNER_IP_PATTERNS=("^172[.]1[6-9].*" "^172[.]2[0-9].*" "^172[.]3[0-1].*" "^10[.].*" "^192[.]168[.].*")
    CONF_FILE="/usr/local/s2/current/conf.yaml"

    function get_host_ip4() {
        local host_ips=$(/usr/sbin/ifconfig -a | grep inet | grep -v inet6 | awk '{print $2}' | tr -d 'addr:')
        echo ${host_ips}
    }

    function is_inn() {
        for p in ${INNER_IP_PATTERNS[*]}; do
            if [[ $1 =~ $p ]]; then
                return 0
            fi
        done
        return 1
    }

    function update_hosts() {
        echo "add local hostdomain:$1 to /etc/hosts"
        $(echo $1 >>/etc/hosts)
    }

    function update_hostname() {
        echo "update hostname:$1 to /etc/hostname"
        $(echo $1 >/etc/hostname)
        $(/usr/bin/hostname $1)
    }

    function parse_yaml() {
        local yaml_file=$1
        local prefix=$2
        local s
        local w
        local fs
        s='[[:space:]]*'
        w='[a-zA-Z0-9_.-]*'
        fs="$(echo @ | tr @ '\034')"
        (
            sed -ne '/^--/s|--||g; s|\"|\\\"|g; s/\s*$//g;' \
                -e "/#.*[\"\']/!s| #.*||g; /^#/s|#.*||g;" \
                -e "s|^\($s\)\($w\)$s:$s\"\(.*\)\"$s\$|\1$fs\2$fs\3|p" \
                -e "s|^\($s\)\($w\)$s[:-]$s\(.*\)$s\$|\1$fs\2$fs\3|p" |
                awk -F"$fs" '{
            indent = length($1)/2;
            if (length($2) == 0) { conj[indent]="+";} else {conj[indent]="";}
            vname[indent] = $2;
            for (i in vname) {if (i > indent) {delete vname[i]}}
                if (length($3) > 0) {
                    vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
                    printf("%s%s%s%s=(\"%s\")\n", "'"$prefix"'",vn, $2, conj[indent-1],$3);
                }
            }' |
                sed -e 's/_=/+=/g' \
                    -e '/\..*=/s|\.|_|' \
                    -e '/\-.*=/s|\-|_|'
        ) <"$yaml_file"
    }

    function create_hostname() {
        eval local "$(parse_yaml "$CONF_FILE")"
        local cluster=${cluster//\'/} # baishan-3copy
        local idc=${idc//\'/}         # .shijiazhuang.xunjie
        echo "s2-${cluster}${idc//./-}-${INN_IP//./-}"
    }

    HOST_IPS=$(get_host_ip4)
    INN_IP=""

    for host_ip in $HOST_IPS; do
        if is_inn $host_ip; then
            INN_IP=$host_ip
            break
        fi
    done

    if [[ $INN_IP != "" ]]; then
        HOSTNAME=$(create_hostname)
        if [[ $HOSTNAME != $(/usr/bin/hostname) ]]; then
            update_hostname "$HOSTNAME"
        fi
        HOSTDOMAIN="$INN_IP $HOSTNAME"
        FLAG=false
        while read line; do
            if [[ $HOSTDOMAIN == $line ]]; then
                FLAG=true
                break
            fi
        done </etc/hosts
        if ! $FLAG; then
            update_hosts "$HOSTDOMAIN"
        fi
    fi
)
