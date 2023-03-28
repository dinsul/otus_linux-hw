#!/bin/sh

echo "####### Создаем раздел GPT на RAID #######"
parted -s /dev/md0 mklabel gpt
echo ""

echo "####### Создаём 5 разделов на RAID-диске #######"
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%
echo ""

for i in $(seq 1 5); do
    echo ""
    echo "##### Создаём раздел md0d$i #####"
    mkfs.ext4 /dev/md0p$i
    echo ""
    echo "##### Монтируем созданный раздел #####"
    mkdir -p /raid/part$i
    mount /dev/md0p$i /raid/part$i
    cd /raid/part$i
    echo -e "\tChecking new partition.\n\tPartition created if you see this text.\n" > test.txt
    cat < test.txt
    cd - > /dev/null
    echo ""
done

ls -Ralh /raid
echo ""
