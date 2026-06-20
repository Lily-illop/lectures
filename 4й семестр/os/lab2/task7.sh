#!/bin/bash

# Временные файлы
START_IO=$(mktemp)
END_IO=$(mktemp)

# Получаем начальные значения read_bytes
for pid in /proc/[0-9]*; do
    if [[ -r "$pid/io" && -r "$pid/cmdline" ]]; then
        read_bytes=$(grep '^read_bytes:' "$pid/io" 2>/dev/null | awk '{print $2}')
        cmdline=$(tr '\0' ' ' < "$pid/cmdline")
        echo "$pid:$read_bytes:$cmdline" >> "$START_IO"
    fi
done

echo "Ожидание 10 секунд..."
sleep 10

# Получаем значения read_bytes через минуту
for pid in /proc/[0-9]*; do
    if [[ -r "$pid/io" ]]; then
        read_bytes=$(grep '^read_bytes:' "$pid/io" 2>/dev/null | awk '{print $2}')
        echo "$pid:$read_bytes" >> "$END_IO"
    fi
done

# Сравниваем и считаем дельту
join -t ":" -j 1 <(sort "$START_IO") <(sort "$END_IO") | awk -F: '
{
    pid=$1;
    start=$2;
    cmdline=$3;
    end=$4;
    diff=end - start;
    if (diff > 0) {
        print pid ":" cmdline ":" diff;
    }
}
' | sort -t ":" -k3,3nr | head -n 3

# Удаление временных файлов
rm "$START_IO" "$END_IO"
