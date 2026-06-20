#!/bin/bash

# Получаем последний запущенный процесс и выводим его PID
#last_pid=$(ps -eo pid,etime --sort=etime | tail -n 1 | awk '{print $1}')

## Получаем PID последнего запущенного процесса, исключая сам ps и другие вспомогательные команды
last_pid=$(ps -eo pid,lstart,comm --sort=start_time | grep -vE "ps|grep|awk|tail|bash" | tail -n 1 | awk '{print $1}')



# Выводим результат
echo "PID последнего запущенного процесса: $last_pid"
