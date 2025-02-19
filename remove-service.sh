#!/bin/bash

path=$(cd -- $(dirname -- "${BASH_SOURCE[0]}") && pwd) 
folder=$(echo $path | awk -F/ '{print $NF}')

read -p "Sure? " c
case $c in y|Y) ;; *) exit ;; esac

systemctl stop $folder.service
systemctl disable $folder.service
rm /etc/systemd/system/$folder.service
