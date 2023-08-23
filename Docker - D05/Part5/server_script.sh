#!/bin/bash

gcc main.c -lfcgi -o main
spawn-fcgi -p 8080 ./main
service nginx start
# нам нужен цикл т.к приложение сразу закрывается
while true; do
    wait
done
/bin/bash