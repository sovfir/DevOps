#!/bin/bash

if [ $# != 0 ]
#Проверяет, если количество аргументов, переданных скрипту через командную строку ($#), не равно нулю.
then
    echo "Error: We dont need any arguments!"
else
    goaccess $(pwd)/../04/log/*.log --log-format=COMBINED -o report.html
    #Выполняет утилиту goaccess для анализа лог-файлов, указанных путем 
    #Опция --log-format=COMBINED указывает формат лог-файла. Результат анализа сохраняется в файл report.html.
    xdg-open report.html
    #Открывает файл report.html в браузере по умолчанию с помощью команды xdg-open. 
    #Это предполагает, что скрипт выполняется в Linux-системе с настроенным браузером по умолчанию.
fi