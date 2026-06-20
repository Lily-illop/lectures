#!/bin/bash

INPUT_FILE="avg_cpu_burst.txt"
OUTPUT_FILE="output_with_avg_children.txt"

# Сортируем файл по PPID
sort -t '=' -k3,3n "$INPUT_FILE" > "$OUTPUT_FILE"

# Читаем отсортированный файл
last_ppid=""
total_art=0
count=0

# Временный файл для хранения данных
temp_file=$(mktemp)

while IFS=' : ' read -r pid ppid art; do
    # Извлекаем значения PID, PPID и ART
    ppid_value=$(echo "$ppid" | cut -d'=' -f2)
    art_value=$(echo "$art" | cut -d'=' -f2)
    
    # Если новый PPID, записываем среднее для предыдущего блока
    if [[ "$ppid_value" != "$last_ppid" && -n "$last_ppid" ]]; then
        # Вычисляем среднее ART
        if [[ $count -gt 0 ]]; then
            avg_art=$(echo "$total_art / $count" | bc -l)
            # Вставляем строку с результатом
            echo "Average_Running_Children_of_ParentID=$last_ppid is $avg_art" >> "$temp_file"
        fi
        # Сбрасываем счетчики для нового PPID
        total_art=0
        count=0
    fi
    
    # Записываем строку с процессом
    echo "$pid : $ppid : $art" >> "$temp_file"

    # Добавляем к сумме ART и увеличиваем счетчик
    total_art=$(echo "$total_art + $art_value" | bc -l)
    ((count++))

    # Обновляем последний PPID
    last_ppid="$ppid_value"

done < "$OUTPUT_FILE"

# Добавляем последний блок данных для последнего PPID
if [[ $count -gt 0 ]]; then
    avg_art=$(echo "$total_art / $count" | bc -l)
    echo "Average_Running_Children_of_ParentID=$last_ppid is $avg_art" >> "$temp_file"
fi

# Переносим данные в конечный файл
cat "$temp_file" > "$OUTPUT_FILE"
rm "$temp_file"

echo "Готово! Средние ART для родителей добавлены в файл $OUTPUT_FILE"
