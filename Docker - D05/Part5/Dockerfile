FROM nginx

ARG USERNAME=nginx

USER root

COPY ./server.c /home/$USERNAME/main.c
COPY ./server_script.sh /home/$USERNAME/start.sh
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf


RUN apt-get update ; \
    apt-get install -y gcc spawn-fcgi libfcgi-dev ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/$USERNAME

RUN usermod -aG adm,root,nginx $USERNAME; \
    chown -R $USERNAME:$USERNAME /var/cache/nginx/ ; \
    chown -R $USERNAME:$USERNAME /var/run/ ; \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/ ; \
    chmod +x /home/$USERNAME/start.sh

USER $USERNAME

ENTRYPOINT ["sh", "./start.sh"]
