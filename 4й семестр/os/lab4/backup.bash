#!/bin/bash

# Текущая дата
TODAY=$(date "+%Y-%m-%d") #+%F)  # YYYY-MM-DD
REPORT="./backup-report"
SOURCE_DIR="./source"
BACKUP_PREFIX="./Backup"
LATEST_BACKUP=""
DAYS_LIMIT=7

if [ ! -d "$SOURCE_DIR" ]; then
    echo "Ошибка: каталог $SOURCE_DIR не найден." >&2
    exit 1
fi


# Поиск последнего backup-каталога
for dir in $(ls -d ${BACKUP_PREFIX}-* 2>/dev/null); do
    dir_date=$(basename "$dir" | cut -d'-' -f2-) # Извлекаем дату из имени каталога (например, из "Backup-2025-05-16" получаем "2025-05-16")
    if date -d "$dir_date" >/dev/null 2>&1; then # Проверяем, является ли значение переменной dir_date корректной датой

#date -d "$dir_date" +%s Преобразует дату $dir_date  в Unix Timestamp.

        days_diff=$(( ( $(date +%s) - $(date -d "$dir_date" +%s) ) / 86400 )) # "/ 86400" Перевод из секунд в дни.
        if [ "$days_diff" -lt "$DAYS_LIMIT" ]; then
            LATEST_BACKUP="$dir"
            break
        fi
    fi
done

# Функция логгирования
log() {
    echo "$1" >> "$REPORT" ## Добавляем в отчёт строку, переданную как первый аргумент при вызове скрипта
}

# Создание новой папки при необходимости
if [ -z "$LATEST_BACKUP" ]; then
    BACKUP_DIR="${BACKUP_PREFIX}-${TODAY}"
    mkdir "$BACKUP_DIR"
    cp "$SOURCE_DIR"/* "$BACKUP_DIR"/
    
    log "Создан новый каталог резервного копирования: $BACKUP_DIR"
    log "Скопированы файлы:"
    for f in "$SOURCE_DIR"/*; do
        log "  $(basename "$f")"
    done
else
    BACKUP_DIR="$LATEST_BACKUP"
    log "Изменения внесены в существующий каталог: $BACKUP_DIR ($(date))"
    for f in "$SOURCE_DIR"/*; do
        filename=$(basename "$f")
        dest_file="$BACKUP_DIR/$filename"
        if [ ! -f "$dest_file" ]; then
            cp "$f" "$dest_file"
            log "  Добавлен новый файл: $filename"
        else
            src_size=$(stat -c%s "$f")
            dest_size=$(stat -c%s "$dest_file")

#stat — утилита, показывающая информацию о файле.
#-c%s — формат вывода: %s означает только размер файла в байтах.
#"$f" — путь к файлу, для которого надо узнать размер.

            if [ "$src_size" -ne "$dest_size" ]; then
                versioned_name="$filename.$TODAY"
                mv "$dest_file" "$BACKUP_DIR/$versioned_name"
                cp "$f" "$dest_file"
                log "  Обновлён файл: $filename (предыдущая версия сохранена как $versioned_name)"
            fi
        fi
    done
fi
