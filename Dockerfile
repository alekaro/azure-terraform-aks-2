FROM nginx:alpine
RUN apk update && apk upgrade
RUN apk add curl
COPY ./init_script.sh ./docker-entrypoint.d/
RUN chmod 777 ./docker-entrypoint.d/init_script.sh
CMD ["/bin/sh"]