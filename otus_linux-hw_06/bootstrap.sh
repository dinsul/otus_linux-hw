#!/bin/sh

echo -e "\n\n### Задача #0. Настраиваем машину, устанавливаем необходимые пакеты"
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
yum install -y redhat-lsb-core rpmdevtools createrepo yum-utils cmake clang python3

echo -e "\n\n### Задача #1. Создаём проект, который будем размещать в нашем репозитории"
mkdir hello
cd hello

echo "#### Исходный код программы"
echo -e "#include <iostream>\n\nint main()\n{\n" \
"    std::cout << \"Hello world!!!\" << std::endl;\n    return 0;\n}\n" > hello.cpp

echo "#### CMake file"
echo -e "cmake_minimum_required(VERSION 3.2)\n" \
"project(hello VERSION 0.0.1)\n" \
"add_executable(\"\${PROJECT_NAME}\" \"\${PROJECT_NAME}.cpp\")\n" \
"install(TARGETS \${PROJECT_NAME} RUNTIME DESTINATION \"/usr/bin\")\n" \
"set(CPACK_GENERATOR RPM)\n" \
"set(CPACK_PACKAGE_VERSION_MAJOR \"\${PROJECT_VERSION_MAJOR}\")\n" \
"set(CPACK_PACKAGE_VERSION_MINOR \"\${PROJECT_VERSION_MINOR}\")\n" \
"set(CPACK_PACKAGE_VERSION_PATCH \"\${PROJECT_VERSION_PATCH}\")\n" \
"set(CPACK_PACKAGE_CONTACT dinsul2.0@gmail.com)\n" \
"include (CPack)" > CMakeLists.txt


echo -e "\n\n### Задача #2. Собираем приложение"
mkdir build
cd build
cmake ..
cmake --build .

echo -e "\n\n#### Проверяем, что приложение собралось и работает"
./hello

echo -e "\n\n### Задача #3. Собираем RPM-пакет"
cmake --build . --target package

echo -e "\n\n### Задача #4. Создаём локальный репозиторий"
mkdir /srv/repo
echo "#### Копируем наш пакет в репозиторий"
mv hello-*.rpm /srv/repo
createrepo /srv/repo

echo -e "\n\n### Задача #5. Запускаем простейший сервер для доступа репозитория по сети"
cd /srv
python3 -m http.server 80 &

echo -e "\n\n### Задача #6. Подключаем репозиторий"
echo -e "[otus]\nname=otus-linux\nbaseurl=http://localhost/repo\ngpgcheck=0\nenabled=1\n" > /etc/yum.repos.d/otus.repo
yum repolist enabled | grep otus
yum list | grep otus

echo -e "\n\n### Задача #7. Устанавливаем наше приложение через репозиторий, и проверяем его"
yum install hello -y
hello


