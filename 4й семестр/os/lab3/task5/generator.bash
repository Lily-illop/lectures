#!/bin/bash

PIPE="./mypipe"

# Проверка существования канала
if [[ ! -p "$PIPE" ]]; then
    echo "Ошибка: именованный канал '$PIPE' не существует. Запустите обработчик."
    exit 1
fi


echo "[Generator] Введите команды ('+', '*', целые числа или 'QUIT')"

while true; do
    read -p "> " INPUT
    echo "$INPUT" > "$PIPE"
    
    if [[ "$INPUT" == "QUIT" ]]; then
        echo "[Generator] Завершение"
        exit 0
    fi
done
