#!/bin/sh

echo "###### Ломаем один диск в RAID'е #######"
mdadm /dev/md0 --fail /dev/sdb
echo ""

echo "###### Проверим #######"
cat /proc/mdstat
echo ""

mdadm -D /dev/md0
echo ""
