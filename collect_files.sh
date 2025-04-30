#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 /путь/к/входной_директории /путь/к/выходной_директории"
    exit 1
fi
input_dir="$1"
output_dir="$2"

if [ ! -d "$input_dir" ]; then
    echo "Ошибка: Входная директория не существует: $input_dir"
    exit 1
fi
mkdir -p "$output_dir"
echo "Входная директория: $input_dir"
echo "Выходная директория: $output_dir"

copy_files() {
    local src="$1"
    local dest="$2"
    for item in "$src"/*; do
        if [ -f "$item" ]; then
            filename=$(basename "$item")
            name="${filename%.*}"
            ext="${filename##*.}"
            if [ "$name" == "$ext" ]; then
                ext=""
                name="$filename"
            else
                ext=".$ext"
            fi
            counter=1
            new_name="$filename"
            while [ -e "$dest/$new_name" ]; do
                new_name="${name}${counter}${ext}"
                counter=$((counter + 1))
            done
            cp "$item" "$dest/$new_name"
            echo "Скопирован файл: $item -> $dest/$new_name"
        elif [ -d "$item" ]; then
            copy_files "$item" "$dest"
        fi
    done
}

copy_files "$input_dir" "$output_dir"

echo "Обработка завершена успешно!"
echo "Все файлы скопированы в: $output_dir"
