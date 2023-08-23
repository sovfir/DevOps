#!/bin/bash
service nginx start
gcc server.c -lfcgi -o server
nginx -s reload
chmod 777 server
spawn-fcgi -p 8080 ./server

while true; do
 wait
done