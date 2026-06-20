#!/bin/bash

PIPE="./pipe"

# Проверка существования pipe
if [[ ! -p "$PIPE" ]]; then
    echo "Pipe не существует. Запустите сначала обработчик."
    exit 1
fi

# Чтение PID из pipe
read HANDLER_PID < "$PIPE"
echo "Генератор запущен. Получен PID обработчика: $HANDLER_PID"
echo "Введите '+', '*', 'TERM' или другие строки:"

while true; do
    read -r LINE
    case "$LINE" in
        "+")
            kill -USR1 "$HANDLER_PID"
            ;;
        "*")
            kill -USR2 "$HANDLER_PID"
            ;;
        "TERM")
            kill -TERM "$HANDLER_PID"
            echo "Генератор завершён."
            break
            ;;
        *)
            # Игнорируем любые другие вводы
            ;;
    esac
done

