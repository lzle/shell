cat: cat: No such file or directory
#!/bin/sh

HOSTNAME=$(hostname)
LAST_MINUTE=$(date -d "1 minute ago" +"%Y-%m-%d %H:%M")
LOG_FILE="/var/log/hdfs/slow_log_report.log"
HDFS_LOG_FILE="/var/log/hadoop-hdfs/hadoop-cmf-hdfs-DATANODE-$HOSTNAME.log.out"
HDFS_VERSION="v3.0.0"
HDFS_CLUSTER="hdfs-picapica"
MALLARD_URL="http://127.0.0.1:10699/v2/push"
CONTENT_TYPE="Content-Type: application/json"

LAST_SLOW_CONTENT=$(grep -E "$LAST_MINUTE.*Slow" "$HDFS_LOG_FILE")

calc_avg_time() {
    local keyword="$1"
    local flag="$2"
    if [ -z "$LAST_SLOW_CONTENT" ]; then
        echo 0
        return
    fi
    local avg_time=$(echo "$LAST_SLOW_CONTENT" | grep "$keyword" |
        awk -F "$flag" '{ total += $2; count++ } END { if (count > 0) print int(total/count) }')
    if [ -z "$avg_time" ]; then
        avg_time=0
    fi
    echo "$avg_time"
}

calc_count() {
    local keyword="$1"
    if [ -z "$LAST_SLOW_CONTENT" ]; then
        echo 0
        return
    fi
    local count=$(echo "$LAST_SLOW_CONTENT" | grep "$keyword" | wc -l)
    echo "$count"
}

log() {
    echo "$1" >>"$LOG_FILE"
}

main() {
    log "Starting script at $(date +"%Y-%m-%d %H:%M:%S")..."
    timestamp=$(date +%s)
    keyword_write_mirror="BlockReceiver write packet to mirror"
    keyword_write_disk="BlockReceiver write data to disk"
    keyword_flush_or_sync="flushOrSync"

    total_count=$(calc_count "Slow")
    echo $total_count
    write_mirror=$(calc_count "$keyword_write_mirror")
    write_disk=$(calc_count "$keyword_write_disk")
    flush_or_sync=$(calc_count "$keyword_flush_or_sync")
    write_disk_avg_cost=$(calc_avg_time "$keyword_write_disk" "cost:|ms")
    write_mirror_avg_cost=$(calc_avg_time "$keyword_write_mirror" "took |ms")
    flush_or_sync_avg_cost=$(calc_avg_time "$keyword_flush_or_sync" "took |ms")

    data='[
    {
        "name": "hdfs_slow_log_report",
        "time": '$timestamp',
        "endpoint": "'"${HOSTNAME}"'",
        "tags": {
            "version": "'"${HDFS_VERSION}"'",
            "cluster": "'"${HDFS_CLUSTER}"'"
        },
        "fields": {
            "write_disk": '$write_disk',
            "write_disk_avg_cost": '$write_disk_avg_cost',
            "flush_or_sync": '$flush_or_sync',
            "flush_or_sync_avg_cost": '$flush_or_sync_avg_cost',
            "write_mirror": '$write_mirror',
            "write_mirror_avg_cost": '$write_mirror_avg_cost'
        },
        "step": 30,
        "value": '$total_count'
    }]'

    resp=$(curl -X POST "$MALLARD_URL" -H "$CONTENT_TYPE" -d "$data")
    log "Report to mallard, post data: $data, result: $resp"
}

main