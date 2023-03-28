#!/bin/sh

echo "####### Удаляем 'сломанный' диск из массива #######"
mdadm /dev/md0 --remove /dev/sdb
echo ""

echo "####### Добавляем другой диск в массив #######"
mdadm /dev/md0 --add /dev/sdf
echo ""

echo "###### Убеждаемся, что процесс перестройки RAID'а запустился #######"
sleep 5
cat /proc/mdstat
echo ""
echo ""

mdadm -D /dev/md0
echo ""
