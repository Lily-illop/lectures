#!/bin/bash

# Очистка report.log
> report.log

array=()
counter=0

while true; do
    # Добавление 10 элементов в массив
    array+=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
    
    # Увеличение счетчика
    ((counter++))
    
    # Запись в лог каждые 100000 шагов
    if ((counter % 100000 == 0)); then
        echo "Размер массива: ${#array[@]}" >> report.log
    fi
done
