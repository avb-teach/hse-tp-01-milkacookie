#!/bin/bash

# Проверка количества аргументов
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_dir> <output_dir>"
    exit 1
fi

input_dir="$1"
output_dir="$2"

# Проверка существования входной директории
if [ ! -d "$input_dir" ]; then
    echo "Error: Input directory '$input_dir' does not exist."
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
        
        # Обработка файлов без расширения
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

echo "Files copied successfully to $output_dir"
