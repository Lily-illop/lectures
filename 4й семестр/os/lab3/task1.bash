#!/bin/bash

# Создание директории ~/test
mkdir ./test 2>>/dev/null && echo "catalog test was created successfully" >> ./report && touch ./test/$(date +"%Y-%m-%d_%H-%M-%S")
#mkdir ~/test 2>>/dev/null — попытка создать директорию, ошибки подавляются


# Пинг хоста www.net_nikogo.ru
ping -c 1 www.net_nikogo.ru > /dev/null 2>> ./report || echo "$(date +"%Y-%m-%d %H:%M:%S") ошибка: хост недоступен" >> ./report
