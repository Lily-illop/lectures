#!/bin/bash
N=$1
array=()
counter=0

while [ ${#array[@]} -lt $N ]; do
    array+=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
    ((counter++))
done

echo "Успешно завершено. Размер массива: ${#array[@]}"
