#!/bin/bash

source ./shlib.sh

PWD=$(pwd)

SOURCE-CODE="
${PWD}/source-code/s2-bs-conf                   master
${PWD}/source-code/s2-doc-pub                   release
${PWD}/source-code/s2-etcd                      master
${PWD}/source-code/s2-kafka                     master
${PWD}/source-code/s2-offline-downloader        master
${PWD}/source-code/s2-zk                        master
${PWD}/source-code/s2                           relese.sdeploy.20211011-928174dfa
${PWD}/source-code/storage-dashboard-vue        release
${PWD}/source-code/storage-dashboard-vue-lanxun       release
${PWD}/source-code/ops                          master
${PWD}/source-code/mysql-devops                 master
${PWD}/source-code/pykit                        master
${PWD}                                          master.sdeploy.20211011
/root/s2                                        master
"

function clean_project_git() {
    while read project branch; do
        if [[ $project != "" && $branch != "" ]]; then
            info clean $project $branch
            cd $project
            git checkout $branch
            for br in $(git branch --list | grep -v "*" ); do
                git branch -D $br
            done
            git checkout --orphan new_branch
            git add -A
            git commit -am 'initial commit' > /dev/null 2>&1
            git branch -D $branch
            git branch -m $branch
        fi
    done <<-END
$PROJECT_DIR
END
}

function clean_data_package() {
    rm  s2/src/ngx/openresty-1.13.6.3 -rf
    rm  s2/src/ngx/openresty-1.13.6.3.tar.gz -rf
}

clean_project_git