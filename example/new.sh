#!/bin/sh

# 全局变量
HOSTNAME=$(hostname)
LOG_FILE="/root/script/mallard_report.log"
HDFS_LOG_FILE="/var/log/hadoop-hdfs/hadoop-cmf-hdfs-DATANODE-$HOSTNAME.log.out"
MALLARD_URL="http://127.0.0.1:10699/v2/push"
LAST_MINUTE=$(date -d "1 minute ago" +"%Y-%m-%d")
CONTENT_TYPE="Content-Type: application/json"

# 计算平均时间函数
calc_avg_time() {
    local keyword="$1"
    local flag="$2"
    local avg_time=$(grep "$LAST_MINUTE" "$HDFS_LOG_FILE" | grep "$keyword" |
        awk -F "$flag" '{ total += $2; count++ } END { if (count > 0) print int(total/count) }')
    echo "$avg_time"
}

# 计算总数函数
calc_count() {
    local keyword="$1"
    local count=$(grep "$LAST_MINUTE" $HDFS_LOG_FILE | grep "$keyword" | wc -l)
    echo "$count"
}

# 记录日志函数
log() {
    echo "$1" >>"$LOG_FILE"
    echo "$1"
}

log "Starting script at $(date +"%Y-%m-%d %H:%M:%S")..."

# 计算数值
timestamp=$(date +%s)
total_count=$(calc_count "Slow")
write_mirror=$(calc_count "Slow BlockReceiver write packet to mirror")
write_disk=$(calc_count "Slow BlockReceiver write data to disk")
flush_or_sync=$(calc_count "Slow flushOrSync")

cost_flag="cost:|ms"
took_flag="took |ms"
write_disk_avg_cost=$(calc_avg_time "Slow BlockReceiver write data to disk" $cost_flag)
write_mirror_avg_cost=$(calc_avg_time "Slow BlockReceiver write packet to mirror" $took_flag)
flush_or_sync_avg_cost=$(calc_avg_time "Slow flushOrSync" $took_flag)

# 发送API请求
data='[
    {
        "name": "hdfs_slow_log_report",
        "time": '$timestamp',
        "endpoint": "'"${HOSTNAME}"'",
        "tags": {
            "version": "v3.0.0",
            "cluster": "hdfs-jinhua"
        },
        "fields": {
            "write_disk": '$write_disk',
            "write_disk_avg_cost": '$write_disk_avg_cost',
            "flush_or_sync": '$flush_or_sync',
            "flush_or_sync_avg_cost": '$flush_or_sync_avg_cost',
            "write_mirror": '$write_mirror',
            "write_mirror_avg_cost": '$write_mirror_avg_cost'
        },
        "step": 60,
        "value": '$total_count'
    }
]'
resp=$(curl -X POST "$MALLARD_URL" -H "$CONTENT_TYPE" -d "$data")

# 记录日志
log "Report to mallard, post data: $data, result: $resp"
