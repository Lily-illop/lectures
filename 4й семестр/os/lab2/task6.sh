#!/bin/bash

max_rss=0
max_pid=0
max_name=""

for pid in /proc/[0-9]*; do
    status_file="$pid/status"
    
    if [[ -r "$status_file" ]]; then
        pid_num=${pid##*/}
        name=$(grep -s "^Name:" "$status_file" | awk '{print $2}')
        rss=$(grep -s "^VmRSS:" "$status_file" | awk '{print $2}')
        
        if [[ -n "$rss" && "$rss" -gt "$max_rss" ]]; then
            max_rss=$rss
            max_pid=$pid_num
            max_name=$name
        fi
    fi
done

echo "Процесс с максимальным использованием памяти:"
echo "PID=$max_pid, Name=$max_name, VmRSS=${max_rss} KB"

echo ""
echo "Проверка через top:"
# отсортирует процессы по использованию памяти (в %).
top -b -o +%MEM | head -n 15
