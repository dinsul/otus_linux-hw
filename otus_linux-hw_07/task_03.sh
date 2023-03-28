#!/bin/sh

echo -e "\n### Добавляем модуль в initrd"

mkdir -p /usr/lib/dracut/modules.d/01test
cd /usr/lib/dracut/modules.d/01test

echo -e "\n#### Создаём скрипт модуля"
cat > module-setup.sh << 'EOF'
#!/bin/bash

check() {
    return 0
}

depends() {
    return 0
}

install() {
    inst_hook cleanup 00 "${moddir}/test.sh"
}
EOF

echo -e "\n#### Создаём вспомогательный скрипт"
cat > test.sh << 'EOF'
#!/bin/bash

exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
cat <<'msgend'
Hello! You are in dracut module!
 ___________________
< I'm dracut module >
 -------------------
   \
    \
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /'\_   _/`\
    \___)=(___/
msgend
sleep 10
echo " continuing...."
EOF

echo -e "\n#### Переносим образ initrd"
dracut -f -v

echo -e "\n#### Проверяем какие модули загружены"
lsinitrd -m /boot/initramfs-$(uname -r).img
echo ""

cd -
