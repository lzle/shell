cat remove_ips.txt| while read line; do echo $line; grep "$line " all-node.md; done
cat remove_ips.txt| while read line; do echo $line; sed -i '' "/$line /d" all-node.md ;done

cat remove_ips.txt| while read line; do grep "$line" baishan-2copy/indexed_hosts.yaml ; done
cat remove_ips.txt| while read line; do echo $line; sed -i ''  "/$line:/d" baishan-2copy/indexed_hosts.yaml ; done

cat remove_ips.txt| while read line; do echo $line; grep "$line$" baishan-2copy/hosts.yaml ; done
cat remove_ips.txt| while read line; do echo $line; sed -i ''  "/$line$/d" baishan-2copy/hosts.yaml ; done
