#!/bin/bash

# Проверка количества параметров
if [ "$#" -ne 1 ]; then
    echo "Ошибка: необходимо передать имя файла для восстановления."
    exit 1
fi

FILENAME="$1"
TRASH_DIR="$HOME/.trash"
LOG_FILE="$HOME/.trash.log"

# Проверка существования лога
if [ ! -f "$LOG_FILE" ]; then
    echo "Файл журнала $LOG_FILE не найден. Восстановление невозможно."
    exit 1
fi

# Поиск всех записей с нужным именем файла
#MATCHES=$(grep " $FILENAME$" "$LOG_FILE")
MATCHES=$(grep " $TRASH_DIR/$FILENAME$" "$LOG_FILE")


if [ -z "$MATCHES" ]; then
    echo "Файл $FILENAME не найден в журнале $LOG_FILE."
    exit 1
fi

echo "$MATCHES" | while read -r line; do
    ORIG_PATH=$(echo "$line" | awk -F ' -> ' '{print $1}')
    TRASH_NAME=$(echo "$line" | awk -F ' -> ' '{print $2}')

    echo "Восстановить файл в: $ORIG_PATH ? [y/n]"
    read -r answer < /dev/tty

    if [[ "$answer" == [Yy] ]]; then
        if [ -e "$TRASH_NAME" ]; then
            DIR_PATH=$(dirname "$ORIG_PATH")

            if [ -d "$DIR_PATH" ]; then
                if [ -e "$ORIG_PATH" ]; then
                    echo "Файл $ORIG_PATH уже существует. Введите новое имя:"
                    read -r NEWNAME
                    ln "$TRASH_NAME" "$DIR_PATH/$NEWNAME" && echo "Восстановлено как $DIR_PATH/$NEWNAME"
                else
                    ln "$TRASH_NAME" "$ORIG_PATH" && echo "Восстановлено как $ORIG_PATH"
                fi
            else
                echo "Каталог $DIR_PATH не существует. Восстанавливаю в домашний каталог..."
                ln "$TRASH_NAME" "$HOME/$FILENAME" && echo "Восстановлено как $HOME/$FILENAME"
            fi

            # Удалить из trash и лог
            rm "$TRASH_NAME"
            grep -v " $TRASH_NAME$" "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
        else
            echo "Файл $TRASH_NAME не найден. Возможно, он уже был восстановлен или удалён вручную."
        fi
    else
        echo "Пропущено."
    fi
done
