#!/bin/bash

RESTORE_DIR="./restore"
BACKUP_PREFIX="./Backup"

# Создаем папку restore, если нет
mkdir -p "$RESTORE_DIR"

# Находим самый свежий каталог бэкапа (по дате в имени)
LATEST_BACKUP=""
LATEST_DATE=0

for dir in ${BACKUP_PREFIX}-*; do
    if [ -d "$dir" ]; then
        dir_date=$(basename "$dir" | cut -d'-' -f2-)
        if date -d "$dir_date" >/dev/null 2>&1; then
            dir_ts=$(date -d "$dir_date" +%s)
            if (( dir_ts > LATEST_DATE )); then
                LATEST_DATE=$dir_ts
                LATEST_BACKUP="$dir"
            fi
        fi
    fi
done

if [ -z "$LATEST_BACKUP" ]; then
    echo "Каталог бэкапов не найден."
    exit 1
fi

echo "Восстанавливаем из: $LATEST_BACKUP"

# Копируем файлы без версионных расширений (*.YYYY-MM-DD)
shopt -s nullglob
for f in "$LATEST_BACKUP"/*; do
    filename=$(basename "$f")
    # Проверяем, что файл НЕ заканчивается на .YYYY-MM-DD (формат даты)
    if [[ ! $filename =~ \.[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        cp "$f" "$RESTORE_DIR/"
        echo "Скопирован файл: $filename"
    fi
done
shopt -u nullglob
