#!/bin/bash
if [ "$#" -ne 2 ]; then
    echo "Ошибка! Необходимо указать 2 аргумента - входную и выходную директории" >&2
    echo "Использование: $0 <входная_директория> <выходная_директория>" >&2
    exit 1
fi
input_dir="$1"
output_dir="$2"
if [ ! -d "$input_dir" ]; then
    echo "Ошибка! Входная директория не существует: $input_dir" >&2
    exit 1
fi

# Создание выходной директории
mkdir -p "$output_dir"

generate_unique_name() {
    local path="$1"
    local filename=$(basename "$path")
    local name="${filename%.*}"
    local ext="${filename##*.}"
    local counter=1
    local new_name="$filename"

    if [ "$name" == "$ext" ]; then
        ext=""
    else
        ext=".$ext"
    fi

    while [ -e "$output_dir/$new_name" ]; do
        new_name="${name}_${counter}${ext}"
        ((counter++))
    done
    echo "$new_name"
}

find "$input_dir" -type f | while read -r file; do
    unique_name=$(generate_unique_name "$file")
    cp "$file" "$output_dir/$unique_name"
    echo "Скопирован: $file -> $output_dir/$unique_name"
done

echo "Готово! Все файлы скопированы в: $output_dir"
exit 0
