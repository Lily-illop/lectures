#!/bin/bash

OUTPUT_FILE="user_processes.txt"
USERNAME="al"

> "$OUTPUT_FILE"

# Получаем список процессов пользователя и записываем PID:команда
count=0
while read -r pid cmd; do
    echo "$pid:$cmd" >> "$OUTPUT_FILE"
    ((count++))
done < <(ps -u "$USERNAME" -o pid=,comm=)

# Вставляем количество процессов в начало файла
sed -i "1i$count" "$OUTPUT_FILE"
