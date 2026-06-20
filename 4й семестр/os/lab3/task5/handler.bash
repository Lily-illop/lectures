#!/bin/bash


PIPE="./mypipe"

# Проверка и создание pipe
if [[ ! -p "$PIPE" ]]; then
    mkfifo "$PIPE"
fi

MODE="add"
VALUE=1

echo "[Handler] Старт. Режим: Сложение. Начальное значение: $VALUE"

while true; do
    if read LINE < "$PIPE"; then
        case "$LINE" in
            "+")
                MODE="add"
                echo "[Handler] Режим переключен на сложение"
                ;;
            "*")
                MODE="mul"
                echo "[Handler] Режим переключен на умножение"
                ;;
            "QUIT")
                echo "[Handler] Плановая остановка. Финальное значение: $VALUE"
                rm -f "$PIPE"
                exit 0
                ;;
            ''|*[!0-9-]*)
		 echo "Некорректный ввод: '$LINE'. Ожидается '+', '*', число или QUIT."
		 continue
#                echo "[Handler] Ошибка: недопустимый ввод '$LINE'"
#                rm -f "$PIPE"
#                exit 1
                ;;
            *)
                if [[ "$MODE" == "add" ]]; then
                    VALUE=$((VALUE + LINE))
                    echo "[Handler] Сложение: новое значение = $VALUE"
                elif [[ "$MODE" == "mul" ]]; then
                    VALUE=$((VALUE * LINE))
                    echo "[Handler] Умножение: новое значение = $VALUE"
                fi
                ;;
        esac
    fi
done
