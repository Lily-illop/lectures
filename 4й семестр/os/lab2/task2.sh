#!/bin/bash

OUTPUT_FILE="pids_from_sbin.txt"
> "$OUTPUT_FILE"

for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    exe_path="/proc/$pid/exe"
    if [ -L "$exe_path" ]; then
        real_path=$(readlink "$exe_path")
        if [[ "$real_path" == /sbin/* || "$real_path" == /usr/sbin/* ]]; then
            echo "$pid : $real_path" >> "$OUTPUT_FILE"
        fi
    fi
done

