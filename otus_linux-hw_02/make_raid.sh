#!/bin/sh

usage()
{
    echo "Usage: $0 NUM"
    echo  -e "\tNUM - number of RAID 0, 1, 5 or 10\n"
}


raid_num=$1
disks_count=0
disks_list=""

case $raid_num in
    0 | 1 )
        disks_count=2
        disks_list="/dev/sdb /dev/sdc"
        ;;

    5 )
        disks_count=3
        disks_list="/dev/sdb /dev/sdc /dev/sdd"
        ;;

    10 )
        disks_count=4
        disks_list="/dev/sdb /dev/sdc /dev/sdd /dev/sde"
        ;;

    * )
        usage
        exit 1
        ;;
esac

echo -e "Your choose $raid_num. Begin!\n"

echo "### Очищаем супер блоки"
mdadm --zero-superblock --force $disks_list
echo ""

echo "### Создаём RAID с заданными параметрами"
echo -e "    тип $raid_num; количество дисков $disks_count; список дисков $disks_list\n"
mdadm --create --verbose /dev/md0 -l $raid_num -n $disks_count $disks_list
echo ""

if [[ "$?" == 0 ]]; then
    sleep 5

    echo -e "####### RAID $raid_num created #######\n    Checking:\n\n"

    cat /proc/mdstat
    echo ""
    echo ""

    mdadm -D /dev/md0
    echo ""

else
    echo "Что-то пошло не так. ERRCODE $?"
    exit 1
fi

