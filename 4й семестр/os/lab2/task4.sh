#!/bin/bash

OUTPUT_FILE="avg_cpu_burst.txt"
> "$OUTPUT_FILE"

for pid_path in /proc/[0-9]*; do
    pid=${pid_path##*/}

    status_file="/proc/$pid/status"
    sched_file="/proc/$pid/sched"

    # Проверка существования и читаемости нужных файлов
    if [[ ! -r "$status_file" || ! -r "$sched_file" ]]; then
        echo "Пропущен PID $pid — нет доступа к status или sched" >&2
        # >&2 == stderr
	continue
    fi

    # Получение PPID
    ppid=$(grep -s "^PPid:" "$status_file" | awk '{print $2}')

    # Получение sum_exec_runtime и nr_switches
    sum_exec_runtime=$(grep -s "se.sum_exec_runtime" "$sched_file" | awk '{print $3}')
    nr_switches=$(grep -s "nr_switches" "$sched_file" | awk '{print $3}')
# echo $(grep -s "nr_switches" "$sched_file" )
# echo "PID=$pid switches=$nr_switches runtime=$sum_exec_runtime"

    # Проверка корректности значений
    if [[ -z "$sum_exec_runtime" || -z "$nr_switches" || "$nr_switches" -eq 0 ]]; then
        echo "Пропущен PID $pid — некорректные значения ART (деление на 0 или пустые данные)" >&2
        continue
    fi

    # Вычисление ART
    art=$(echo "scale=3; $sum_exec_runtime / $nr_switches" | bc)

    echo "ProcessID=$pid : Parent_ProcessID=$ppid : Average_Running_Time=$art" >> "$OUTPUT_FILE"
done

# Сортировка по PPID
sort -t '=' -k3,3n "$OUTPUT_FILE" -o "$OUTPUT_FILE"

echo "Готово! Результаты записаны в $OUTPUT_FILE"
