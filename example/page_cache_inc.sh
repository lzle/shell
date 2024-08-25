#!/bin/sh

#这是我们用来解析的文件
MEM_FILE="/proc/meminfo"

#这是在该脚本中将要生成的一个新文件
NEW_FILE="/home/yafang/dd.write.out"

#我们用来解析的Page Cache的具体项
active=0
inactive=0
pagecache=0

IFS=' '

#从/proc/meminfo中读取File Page Cache的大小
function get_filecache_size() {
    items=0
    while read line; do
        if [[ "$line" =~ "Active:" ]]; then
            read -ra ADDR <<<"$line"
            active=${ADDR[1]}
            let "items=$items+1"
        elif [[ "$line" =~ "Inactive:" ]]; then
            read -ra ADDR <<<"$line"
            inactive=${ADDR[1]}
            let "items=$items+1"
        fi

        if [ $items -eq 2 ]; then
            break
        fi
    done <$MEM_FILE
}

#读取File Page Cache的初始大小
get_filecache_size
let filecache="$active + $inactive"

#写一个新文件，该文件的大小为1048576 KB
dd if=/dev/zero of=$NEW_FILE bs=1024 count=1048576 &>/dev/null

#文件写完后，再次读取File Page Cache的大小
get_filecache_size

#两次的差异可以近似为该新文件内容对应的File Page Cache
#之所以用近似是因为在运行的过程中也可能会有其他Page Cache产生
let size_increased="$active + $inactive - $filecache"

#输出结果
echo "File size 1048576KB, File Cache increased" size_increased
