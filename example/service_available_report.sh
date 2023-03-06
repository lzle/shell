#!/bin/sh

HOSTNAME=$(hostname)
UPLOAD_DIR="/tmp/.service_available_monitor"
LOCAL_FILE="/opt/hadoop/script/1M.file"
LOG_FILE="/var/log/hdfs/service_available_report.log"
HDFS_VERSION="v2.6.0"
HDFS_CLUSTER="hdfs-jinhua"
MALLARD_URL="http://127.0.0.1:10699/v2/push"
CONTENT_TYPE="Content-Type: application/json"

log() {
    echo "$1" >>"$LOG_FILE"
}

prepare_work() {
    # create hdfs availability uploaded dir
    if ! $(hdfs dfs -test -d $UPLOAD_DIR); then
        hdfs dfs -mkdir $UPLOAD_DIR
        log "Create hdfs dir $UPLOAD_DIR"
    fi

    # create test file to put
    if [ ! -f $LOCAL_FILE ]; then
        dd if=/dev/zero of=$LOCAL_FILE bs=1M count=1 >/dev/null 2>&1
        log "Create file $LOCAL_FILE"
    fi
}

put_file() {
    local resp=$(timeout 20 hdfs dfs -put $LOCAL_FILE $UPLOAD_FILE)
    if [ $? -eq 0 ]; then
        log "Put file $UPLOAD_FILE successfully!!"
        echo 200
    elif [ $? -eq 143 ]; then
        log "Failed to put file $UPLOAD_FILE!! resp message timeout"
        echo 408
    else
        log "Failed to put file $UPLOAD_FILE!! resp message $resp"
        echo 500
    fi
}

get_file() {
    local resp=$(timeout 20 hdfs dfs -cat $UPLOAD_FILE)
    if [ $? -eq 0 ]; then
        log "Get file $UPLOAD_FILE successfully!!"
        echo 200
    elif [ $? -eq 143 ]; then
        log "Failed to get file $UPLOAD_FILE!! resp message timeout"
        echo 408
    else
        log "Failed to get file $UPLOAD_FILE!! resp message $resp"
        echo 500
    fi
}

delete_file() {
    local resp=$(timeout 20 hdfs dfs -rm $UPLOAD_FILE >/dev/null 2>&1)
    if [ $? -eq 0 ]; then
        log "Delete file $UPLOAD_FILE successfully!!"
        echo 200
        return
    elif [ $? -eq 143 ]; then
        log "Failed to delete file $UPLOAD_FILE!! resp message timeout"
        echo 408
    else
        log "Failed to delete file $UPLOAD_FILE!! resp message $resp"
        echo 500
        return
    fi
}

cacl_cost_time() {
    local start_time="$1"
    local end_time=$(date +%s.%N)
    local cost_time=$(echo "($end_time - $start_time) * 1000" | bc -l | awk '{printf "%.2f", $0}')
    echo $cost_time
}

report() {
    TIMESTAMP=$(date +%s)
    UPLOAD_FILE="${UPLOAD_DIR}/${HOSTNAME}_${TIMESTAMP}.file"

    # put
    local start_time=$(date +%s.%N)
    local put_code=$(put_file)
    local put_cost=$(cacl_cost_time $start_time)

    # get
    local start_time=$(date +%s.%N)
    local get_code=$(get_file)
    local get_cost=$(cacl_cost_time $start_time)

    # delete
    local start_time=$(date +%s.%N)
    local delete_code=$(delete_file)
    local delete_cost=$(cacl_cost_time $start_time)

    local rest_code=$(($put_code | $get_code | $delete_code))
    if [ ! $rest_code -eq 200 ]; then
        local rest_code=500
    fi

    data='[
    {
        "name": "hdfs_service_availability_report",
        "time": '$TIMESTAMP',
        "endpoint": "'"${HOSTNAME}"'",
        "tags": {
            "version": "'"${HDFS_VERSION}"'",
            "cluster": "'"${HDFS_CLUSTER}"'"
        },
        "fields": {
            "put": '$put_code',
            "put_cost": '$put_cost',
            "get": '$get_code',
            "get_cost": '$get_cost',
            "delete": '$delete_code',
            "delete_cost": '$delete_cost'
        },
        "step": 20,
        "value": '$rest_code'
    }]'

    resp=$(curl -X POST "$MALLARD_URL" -H "$CONTENT_TYPE" -d "$data")
    log "Report to mallard, post data: $data, result: $resp"
}

main() {
    # random sleep 0-5s to prevent stabbing access
    sleep $(shuf -i 0-5 -n 1)

    log "Starting script at $(date +"%Y-%m-%d %H:%M:%S")..."
    prepare_work

    # crontab */1 * * * * /bin/sh this_script.sh
    # report needs to be executed every 20 seconds, so the report
    # function needs to be executed three times in this script

    # first
    local start_time=$(date +%s)
    report
    local cost=$(($(date +%s) - $start_time))

    # second
    if [ $cost -lt 20 ]; then
        sleep $(( $(( 20 - $cost )) / 2))
        report
        local cost=$(($(date +%s) - $start_time))
    fi

    # third
    if [ $cost -lt 40 ]; then
        sleep $(( $(( 40 - $cost )) / 2))
        report
    fi

    log "Complete script processing at $(date +"%Y-%m-%d %H:%M:%S")"
}

main