#!/bin/bash

# Проверка, понедельник ли сегодня
if [ "$(date +%u)" -eq 1 ]; then
    echo "Сегодня понедельник. Добавляем задание в crontab..."

    # Путь к скрипту
    SCRIPT_PATH="/home/al/Documents/os/lab3/task1.bash"

    # Проверка, есть ли уже такая строка в crontab
    crontab -l | grep -q "$SCRIPT_PATH" && echo "Задание уже существует в crontab." && exit 0

    # Добавляем задание в crontab
    (crontab -l 2>/dev/null; echo "5 * * * 1 $SCRIPT_PATH") | crontab -

    echo "Задание успешно добавлено!"
else
    echo "Сегодня не понедельник. Скрипт ничего не делает."
fi
