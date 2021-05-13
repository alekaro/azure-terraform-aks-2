FROM nginx:alpine
RUN apk update && apk upgrade

RUN apk add --no-cache wget libc6-compat\
&&	wget https://aka.ms/downloadazcopy-v10-linux \
&&	tar -xvf downloadazcopy-v10-linux \
&&	cp ./azcopy_linux_amd64_*/azcopy /usr/bin/

RUN \
  apk update && \
  apk add bash py-pip && \
  apk add --virtual=build gcc libffi-dev musl-dev openssl-dev python3-dev make && \
  pip --no-cache-dir install -U pip && \
  pip --no-cache-dir install azure-cli && \
  apk del --purge build

COPY ./init_script.sh ./docker-entrypoint.d/
RUN chmod 777 ./docker-entrypoint.d/init_script.sh