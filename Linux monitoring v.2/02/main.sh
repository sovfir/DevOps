#!/bin/bash

# Функция для генерации случайного имени файла или папки на основе переданных символов
function generate_name() {
    local chars="$1"  # Получение переданных символов
    local min_length=5  # Минимальная длина имени
    local name=""  # Переменная для хранения сгенерированного имени
    
    for ((i=0; i<$min_length; i++)); do
        name="${name}${chars:$((RANDOM % ${#chars})):1}"  # Случайный выбор символа из переданных символов и добавление к имени
    done
    
    echo "${name}"  # Возврат сгенерированного имени
}

# Функция для проверки доступного свободного места на диске
function check_freespace() {
    local available_space=$(df --output=avail / | tail -1)  # Получение доступного места на диске
    local min_space=$((1024 * 1024))  # Минимальное доступное место (1MB)
    
    if [[ $available_space -lt $min_space ]]; then  # Проверка доступного места
        echo "Error: No free space for file generation."  # Вывод ошибки при недостатке свободного места
        exit 1
    fi
}

# Функция для генерации файлов и папок
function ft_file_and_folder_generator() {
    local folder_letters="$1"  # Переданные символы для генерации имени папки
    local file_letters="$2"  # Переданные символы для генерации имени файла
    local ext_chars="${file_letters:0:3}"  # Получение первых трех символов для расширения файла
    local size="$3"  # Размер файла
    local log_file="$4"  # Путь к файлу журнала
    local date_suffix=$(date '+%d%m%y')  # Получение суффикса даты для имени папки
    
    for ((i=0; i<100; i++)); do
        check_freespace
        
        local folder_name="$(generate_name "$folder_letters")_${date_suffix}"  # Генерация имени папки
        local folder_path="$(pwd)/log/${folder_name}"  # Формирование пути к папке
        
        mkdir -p "$folder_path"  # Создание папки
        
        local num_files=$((RANDOM % 100 + 1))  # Генерация случайного числа файлов
        
        for ((j=0; j<$num_files; j++)); do
            check_freespace
            
            local file_name="$(generate_name "$file_letters")_${date_suffix}"  # Генерация имени файла
            local file_ext="$(generate_name "$ext_chars")"  # Генерация расширения файла
            local file_path="${folder_path}/${file_name}.${file_ext}"  # Формирование пути к файлу
            
            truncate -s "${size}M" "$file_path"  # Создание файла заданного размера
            
            echo "$(date '+%Y-%m-%d %H:%M:%S') | Created: ${file_path} | Size: ${size}M" >> "$log_file"  # Запись информации о созданном файле в журнал
        done
    done
}

# Основная функция
function main() {
    if [[ $# -ne 3 ]]; then  # Проверка количества переданных аргументов
        echo "Error: Wrong number of arguments!."  # Вывод ошибки при неправильном количестве аргументов
        echo "      Usage: $0 <folder_letters> <file_letters> <size>"
        exit 1
    fi
    
    local folder_letters="$1"  # Символы для генерации имени папки
    local file_letters="$2"  # Символы для генерации имени файла
    local size="$3"  # Размер файла
    
    if ! [[ $size =~ ^[0-9]+$ ]]; then  # Проверка, является ли размер числом
        echo "Error: $0 ... ... <size> is not a number."  # Вывод ошибки при неверном формате размера
        exit 1
    fi
    
    if [[ $size -gt 100 ]]; then  # Проверка, превышает ли размер 100MB
        echo "Error: File size is bigger 100MB."  # Вывод ошибки при превышении размера
        exit 1
    fi
    
    local log_file="$(pwd)/log/creation_log_$(date '+%d%m%y').txt"  # Формирование пути к файлу журнала
    local start_timepoint=$(date '+%Y-%m-%d %H:%M:%S')  # Запись времени начала выполнения скрипта
    local start_seconds=$(date +%s)  # Получение количества секунд с начала эпохи
    
    ft_file_and_folder_generator "$folder_letters" "$file_letters" "$size" "$log_file"  # Генерация файлов и папок
    
    local end_timepoint=$(date '+%Y-%m-%d %H:%M:%S')  # Запись времени окончания выполнения скрипта
    local end_seconds=$(date +%s)  # Получение количества секунд с начала эпохи
    local total_time=$((end_seconds - start_seconds))  # Вычисление общего времени выполнения скрипта
    
    echo "Time of start: $start_timepoint" >> "$log_file"  # Запись времени начала выполнения в журнал
    echo "Finish time: $end_timepoint" >> "$log_file"  # Запись времени окончания выполнения в журнал
    echo "Total runtime: ${total_time} seconds" >> "$log_file"  # Запись общего времени выполнения в журнал
    
    echo "Time of start: $start_timepoint"  # Вывод времени начала выполнения
    echo "Finish time: $end_timepoint"  # Вывод времени окончания выполнения
    echo "Total runtime: ${total_time} seconds"  # Вывод общего времени выполнения
}

main "$@"  # Вызов основной функции с переданными аргументами