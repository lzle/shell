#!/bin/bash

# 1、执行公司统一的初始化脚本
# curl http://mon.ort.sealaly.com/init.sh | sh -s -- --s2 --ipmi-password $password
# curl http://s2.i.qingcdn.com/s2-package/init-s2/init-s2.sh | sh -s s2 s8t baishancloud2022

# # 2、添加 ansible 机器公钥，开启root可以登录
# ssh-keygen -f ~/.ssh/id_rsa -P '' -q
# cat >> /root/.ssh/authorized_keys << EOF
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC2bHj6W+OqJ+usJkK2IgNaVJQvHbsB9d71Z1Ph/zxenY5qqI7T2RaZzc0h8Rl+6+ZiQjNVl+3YGTJDRqzgtEbe/LrJkXp5L0GPhEBcTC9hqxKqHNLzpgSLhiUYrGBSPJXUaH16JVzqvVb8b58yFdGKOszQAtYSRljnyqxJg+IkxzhPqIuYgjd34uGcf2lTBRJc6KhkR/NuPXOfjG4CSnjhm1EnZGnCWUtMHu5awfbcofwCc3NiMteSmfpU9Mh+OoMQcLQFVHr6HVE3gdO/FE2Vjwh6mT+9LxtYH7rVyoAsuHFnyjR7s87l019BafXq8VpePf0tkaUtxEnY5z6dXx+1 root@s2-baishan-3copy-shijiazhuang-xunjie-10-101-0-27
# EOF
# sed -i '/Port 10022/a Port 22' /etc/ssh/sshd_config
# sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config && systemctl reload sshd

# 3、修改密码
echo $password | passwd --stdin root

# 4、设置ipmi密码
curl http://ss.bscstorage.com/baishan-s2/script/init_ipmi_set.sh | env password=$password sh

# 5、检查ipmi设置
curl http://ss.bscstorage.com/baishan-s2/script/check_ipmi_set.sh | env password=$password sh
