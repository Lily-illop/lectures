#!/bin/bash

# Проверка наличия аргумента
if [ $# -ne 1 ]; then
    echo "Ошибка: необходимо указать имя файла." >&2
    exit 1
fi

FILENAME="$1"
TRASH_DIR="$HOME/.trash"
LOG_FILE="$HOME/.trash.log"

# Проверка существования файла
if [ ! -e "$FILENAME" ]; then
    echo "Ошибка: файл '$FILENAME' не существует." >&2
    exit 1
fi

# Проверка, является ли это файлом
if [ ! -f "$FILENAME" ]; then
    echo "Ошибка: '$FILENAME' не является обычным файлом." >&2
    exit 1
fi

# Создание каталога .trash при необходимости
if [ ! -d "$TRASH_DIR" ]; then
    mkdir -p "$TRASH_DIR" || {
        echo "Ошибка: не удалось создать каталог $TRASH_DIR" >&2
        exit 1
    }
fi

# Определение следующего уникального имени ссылки
i=1
while [ -e "$TRASH_DIR/$i" ]; do
    i=$((i + 1))
done

# Получение абсолютного пути к файлу
ABS_PATH="$(realpath "$FILENAME")"

# Создание жёсткой ссылки
ln "$FILENAME" "$TRASH_DIR/$i" || {
    echo "Ошибка: не удалось создать жёсткую ссылку." >&2
    exit 1
}

# Удаление оригинального файла
rm "$FILENAME" || {
    echo "Ошибка: не удалось удалить исходный файл." >&2
    exit 1
}

# Запись в лог
echo "$ABS_PATH -> $TRASH_DIR/$i" >> "$LOG_FILE"

echo "Файл '$FILENAME' перемещён в корзину как '$TRASH_DIR/$i'."
