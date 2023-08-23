#!/bin/bash

# Исходные массивы
declare -a codes=("201" "500" "403" "200" "404" "401" "502" "503" "400" "501")
declare -a req_methods=("DELETE" "PUT" "POST" "PATCH" "GET")
declare -a clients=("Safari" "Internet Explorer" "Opera" "Google Chrome" "Microsoft Edge" "Library and net tool" "Yandex Bot" "Mozilla")

# В данном участке кода объявляются три массива:
# codes: Массив, содержащий различные коды ответов HTTP, которые могут быть записаны в журнале.
# req_methods: Массив, содержащий различные HTTP-методы, которые могут быть использованы в запросах.
# clients: Массив, содержащий различные User-Agent'ы (идентификаторы браузеров или других клиентских программ), которые могут быть записаны в журнале.

for i in {1..5}; do
#Это цикл for, который выполняется пять раз, от i = 1 до i = 5. Он используется для создания пяти журналов для каждого дня.
    log_file="nginx_log_day_${i}.log"
    # Создается переменная log_file, которая содержит имя файла журнала в нужном формате 
    mkdir -p "log/"
    #Создается директория log/, если она не существует. Опция -p позволяет создавать вложенные директории при необходимости.
    touch "log/$log_file"
    #Создается пустой файл с именем, содержащимся в переменной log_file, внутри директории log/. Если файл уже существует, он будет обновлен.
    num_entries=$((RANDOM % 901 + 100))
    #Генерируется случайное число num_entries в диапазоне от 100 до 1000 (включительно). Оно указывает количество записей, которые будут добавлены в журнал.
    for ((j = 0; j < num_entries; j++)); do
    #Вложенный цикл for, который выполняется num_entries раз для генерации указанного количества записей в журнале.
        ip="$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1).$(shuf -i 1-255 -n 1)"
        #Генерируется случайный IP-адрес, состоящий из четырех чисел, разделенных точками. Каждое число генерируется случайным образом в диапазоне от 1 до 255.
        #команда shuf. Опция -i указывает диапазон чисел, -n указывает количество случайных чисел, которые нужно сгенерировать (в данном случае 1). 
        response_code="${codes[RANDOM % ${#codes[@]}]}"
        #Выбирается случайный элемент из массива response_codes и сохраняется в переменную response_code. 
        #${#response_codes[@]} возвращает количество элементов в массиве.
        method="${req_methods[RANDOM % ${#req_methods[@]}]}"
        #Выбирается случайный элемент из массива methods и сохраняется в переменную method. ${#methods[@]} возвращает количество элементов в массиве.
        date="$(date -d "today -${i} days" "+%d/%b/%Y:%H:%M:%S %z")"
        #Создается переменная date, содержащая текущую дату и время с учетом значения переменной i. Опция -d "today -${i} days" 
        #указывает на смещение относительно текущей даты, где ${i} заменяется значением переменной i. Формат `"+%d/%b/%Y:%H
        request_url="/path/to/resource"
        #Здесь просто определяется фиксированный URL запроса "/path/to/resource". В реальном приложении это может быть конкретный путь к ресурсу на сервере.
        user_agent="${clients[RANDOM % ${#clients[@]}]}"
        # Эта строка выбирает случайный элемент из массива clients и присваивает его переменной user_agent. ${#clients[@]} возвращает длину массива clients, а RANDOM % ${#clients[@]} генерирует случайное число в диапазоне от 0 до (длина массива - 1). 
        # Таким образом, случайный элемент из массива clients выбирается с помощью оператора %.
        
        echo "$ip - - [$date] \"$method $request_url HTTP/1.1\" $response_code 0 \"-\" \"$user_agent\"" >> "log/$log_file"
        # В этой строке генерируется строка журнала, содержащая значения переменных ip, date, method, request_url, response_code и user_agent. 
        # Строка журнала затем добавляется в файл лога (log/$log_file) с помощью оператора >>. 
        # Каждая запись в файле лога представляет собой строку в формате, используемом в журналах Nginx.
    done
done