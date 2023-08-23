#!/bin/bash

while true; do
    # Собираем дланные
    #Эта строка собирает информацию о загрузке процессора. 
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    #команда free -m для получения информации о памяти и awk для извлечения значения общей памяти.
    total_memory=$(free -m | awk 'NR==2{print $2}')
    #Эта строка собирает информацию о использовании диска. Она использует команду df -h / для получения информации о 
    #диске и awk для извлечения процентного использования диска. tr -d '%' удаляет символ процента.
    used_memory=$(free -m | awk 'NR==2{print $3}')
    disk_usage=$(df -h / | awk 'NR==2{print $5}' | tr -d '%')
    
    # CЭта строка создает файл /var/www/html/metrics.html и перенаправляет вывод следующих строк в этот файл.
    cat << EOF > /var/www/html/metrics.html
# HELP cpu_usage CPU USAGE in %
# TYPE cpu_usage gauge
cpu_usage $cpu_usage
# HELP total_memory TOTAL MEMORY IN MB
# TYPE total_memory gauge
total_memory $total_memory
# HELP used_memory USED MEMORY IN MB
# TYPE used_memory gauge
used_memory $used_memory
# HELP disk_usage DISK USAGE IN %
# TYPE disk_usage gauge
disk_usage $disk_usage
EOF
    
    # Обновляемся каждые 3 секунды
    sleep 3
done