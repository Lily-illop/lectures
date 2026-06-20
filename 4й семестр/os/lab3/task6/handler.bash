#!/bin/bash

PIPE="./pipe"
VALUE=1
OPERATION="add"
RUNNING=true

# Проверка и создание pipe
if [[ ! -p "$PIPE" ]]; then
    mkfifo "$PIPE"
fi

# Запись PID в pipe
echo $$ > "$PIPE"

# Обработка сигналов
trap 'OPERATION="add"' USR1
trap 'OPERATION="mul"' USR2
trap 'echo "Обработчик завершает работу по сигналу SIGTERM от другого процесса"; RUNNING=false' SIGTERM

echo "Обработчик запущен (PID $$), стартовое значение: $VALUE"

# Главный цикл
while $RUNNING; do
    sleep 1
    if [[ "$OPERATION" == "add" ]]; then
        VALUE=$((VALUE + 2))
    elif [[ "$OPERATION" == "mul" ]]; then
        VALUE=$((VALUE * 2))
    fi
    echo "Текущее значение: $VALUE"
done

echo "Обработчик завершён."

