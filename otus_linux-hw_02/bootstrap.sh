#!/bin/sh

mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
yum install -y mdadm smartmontools hdparm gdisk

echo "####### Проверяем количество дисков в системе #######"
if [[ `ls /dev/sd? | wc -l` == 6 ]]; then 
    echo "    count of disks is well"
else
    echo "Wrong disks count"
    exit 1
fi

echo "Welcome!!!"
