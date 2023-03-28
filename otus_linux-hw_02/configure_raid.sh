#!/bin/sh

echo -e "####### Создаём конфигурационный файла #######\n"
mdadm --detail --scan --verbose
echo ""

if [[ "$?" == 0 ]]; then
    mkdir -p /etc/mdadm
    echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
    mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf

else
    echo "Что-то пошло не так. ERRCODE $?"
    exit 1
fi

