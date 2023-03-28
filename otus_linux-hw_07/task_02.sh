#!/bin/sh

echo -e "\n### Переименовываем VG"

replace_in_file()
{
    if [ "$#" -ne 3 ]; then
        echo "Wrong arguments"
        exit 1
    fi

    cp -f $1 $1.bak
    sed 's/\([^a-z]\)'$2'\([^a-z]\)/\1'$3'\2/g' $1.bak > $1
}

old_name="VolGroup00"
new_name="OtusRoot"

echo -e "\n#### Проверяем текущее состояние томов"
vgs
echo ""

vgrename $old_name $new_name

for file in /etc/fstab /etc/default/grub /boot/grub2/grub.cfg; do
    replace_in_file $file $old_name $new_name
done

mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

echo -e "\n#### Проверяем новое состояние томов"
vgs
echo ""

touch /.autorelabel
