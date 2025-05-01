#!/bin/bash

if [ "$#" -ne 2 ]; then
    exit 1
fi

input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
    echo ": Ошибка! Входная директория '$input_dir' не существует."
    exit 1
fi
mkdir -p "$output_dir"
declare -A file_counts

process_file() {
    local src_file="$1"
    local filename=$(basename "$src_file")
    if [[ -e "$output_dir/$filename" ]]; then
        ((file_counts["$filename"]++))
        local suffix="${file_counts["$filename"]}"
        local base="${filename%.*}"
        local ext="${filename##*.}"

        if [[ "$base" == "$ext" ]]; then
            new_filename="${base}${suffix}"
        else
            new_filename="${base}${suffix}.${ext}"
        fi

        cp "$src_file" "$output_dir/$new_filename"
    else
        cp "$src_file" "$output_dir/$filename"
        file_counts["$filename"]=0
    fi
}

export -f process_file
export output_dir
export file_counts

find "$input_dir" -type f -exec bash -c 'process_file "$0"' {} \;

echo "Файлы скопированы успешно в $output_dir ю."
