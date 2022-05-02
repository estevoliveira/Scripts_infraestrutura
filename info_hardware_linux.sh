#!/bin/bash

lista_servidor=$1
echo "INSTANCIA;CORE;MEMORIA;DISCO;OS;REDE"

for server in $(cat $lista_servidor);do

result=$(ssh $server << 'EOF'
    core=$(lscpu | grep -iP "^cpu\(s\):" | awk '{print $2}')

    os=$(hostnamectl | grep -i "os name:" | awk '{print $4}' | awk -F':' '{print $3" "$4" "$7" "$5}')

    mem=$(free -h | head -n2 | tail -n1 | awk '{print $2}')

    disco=$(lsblk | head -n2 | tail -n1 | awk '{print $4}')

    for interface in $(ifconfig | grep -Po "em\d:" | perl -pe 's/(em\d):/\1/');do
      eth=$eth""$(echo "$interface: $(cat /sys/class/net/$interface/speed)Mb/s ")
    done


    echo "$core;$mem;$disco;$os;$eth"

    unset core
    unset os
    unset mem
    unset disco
    unset eth
EOF)
echo "${server};$(echo "$server;$result" | grep -vi "version" | grep -vi "Pseudo-terminal")"
done
