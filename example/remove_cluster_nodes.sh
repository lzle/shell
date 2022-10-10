
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


# 添加免密登陆公钥
cat ip_list | while read line; do echo $line; ip=$line; ssh -n -tt -o StrictHostKeychecking=no -o ConnectTimeout=5 root@$ip 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDMDQ7t/Df96g2qkmJSpeMwps95VY38/KOLLHrNSjgPrIKpHygUF1JpzrEMWjGe6ori+fal6z/ozK8GG1WXCR1CHS4v9x8cdJtFsM+50+CpWoa0RZy1XPSmRT4F9x8n/xxq6O2Fu7Cfd9mDHXDdYVZqJfBGo9CACUQ+u70Z2Ey+V8SFgHT7fqpIl+AXO3K5zBkkXA/ba7iuoWwNQ4eIbUE0y/gwi8s4zTlCGSaMtHhtaVHpQLar1hmvHFNoerlP7hWMUAyB0v+vfDnNBroxlWB4sVql2LXjUvkGfcTQjZ4ri49bYM2TkzjniJ/RT17QN5eq75issk+Kof1f9f9/LETB root@s2-baishan-3copy-ningbo-yinzhou-10-104-18-156" >>/root/.ssh/authorized_keys'; done