#!/bin/sh

reconfig()
{
    echo "Меняем root на /mnt/tmp_root и обновляем grub"

    for i in /proc/ /sys/ /dev/ /run/ /boot/; do
        mount --bind $i /mnt/$i
    done  

    chroot /mnt/tmp_root  
    grub2-mkconfig -o /boot/grub2/grub.cfg  

    cd /boot
    for i in `ls initramfs-*img`; do
        dracut -v $i `echo $i|sed "s/initramfs-//g; s/.img//g"` --force
    done  

    cd -
}

echo "Подготовим том для временного root'а"

pvcreate /dev/sdb
vgcreate vg_root /dev/sdb
lvcreate -n lv_root -l +100%FREE /dev/vg_root

mkfs.xfs /dev/vg_root/lv_root
mkdir -p /mnt/tmp_root
mount /dev/vg_root/lv_root /mnt/tmp_root

echo "Копируем данные из / в /mnt/tmp_root"

xfsdump -J - /dev/VolGroup00/LogVol00 | xfsrestore -J - /mnt/tmp_root


reconfig

echo "Изменяем размер старой VG"

lvremove /dev/VolGroup00/LogVol00
lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00

echo "Создаём ФС и копируем данные"

mkfs.xfs /dev/VolGroup00/LogVol00
mount /dev/VolGroup00/LogVol00 /mnt/tmp_root
xfsdump -J - /dev/vg_root/lv_root | xfsrestore -J - /mnt/tmp_root

reconfig

umount /mnt/tmp_root

