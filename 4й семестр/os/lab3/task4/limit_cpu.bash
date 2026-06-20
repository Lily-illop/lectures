#!/bin/bash

PID=$1

if [ -z "$PID" ]; then
    echo "Укажи PID процесса, который нужно ограничить."
    exit 1
fi

echo "Ограничиваем процесс $PID до ~10% CPU. Нажми Ctrl+C для остановки."

while true; do

if kill -0 $PID 2>/dev/null; then
    kill -STOP $PID
else
    echo "Процесс $PID уже завершён"
fi      # приостановка процесса

  sleep 0.9            # простаивает 90% времени

if kill -0 $PID 2>/dev/null; then
    kill -CONT $PID
else
    echo "Процесс $PID был уже завершён, нам нечего возобновлять"
fi     # возобновление

    sleep 0.1            # работает 10% времени
done
