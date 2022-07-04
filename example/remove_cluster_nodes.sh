
# check
cat /tmp/remove_ips.txt | while read line; do echo $line; grep "$line " all-node.md; done
cat /tmp/remove_ips.txt | while read line; do echo $line; sed -i '' "/$line /d" all-node.md ;done

cat /tmp/remove_ips.txt | while read line; do grep "$line:" baishan-2copy/indexed_hosts.yaml ; done
cat /tmp/remove_ips.txt | while read line; do echo $line; sed -i ''  "/$line:/d" baishan-2copy/indexed_hosts.yaml ; done

cat /tmp/remove_ips.txt | while read line; do echo $line; grep "$line$" baishan-2copy/hosts.yaml ; done
cat /tmp/remove_ips.txt | while read line; do echo $line; sed -i ''  "/$line$/d" baishan-2copy/hosts.yaml ; done

cat /tmp/remove_ips.txt | while read line; do echo $line; ip=$line; ssh -n -tt -o StrictHostKeychecking=no -o ConnectTimeout=5 root@$ip ps -ef| grep -E "front|core|zabbix_proxy|zabbix-host-manage|etcd|kafka|mysql|zookeeper|dashboard"; done

# s2mgr
cat /tmp/remove_ips.txt | while read line; do s2mgr.py -e "partition remove $line"; done
cat /tmp/remove_ips.txt | while read line; do s2mgr.py -e "node role unset Storage  $line"; done
cat /tmp/remove_ips.txt | while read line; do s2mgr.py -e "node role unset Memcached  $line"; done
cat /tmp/remove_nodes.txt | while read line; do s2mgr.py -e "node delete $line"; done
