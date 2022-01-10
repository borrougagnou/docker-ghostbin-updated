FROM golang:1.17.6-alpine3.15

RUN apk add --update \
    git \
    py-pygments \
    sudo \
    nodejs npm && npm install npm@latest -g \
    && rm -rf /var/cache/apk/* \
    && adduser -h /ghostbin -u 10000 -D -g "" ghostbin
USER ghostbin
ENV GOPATH=/ghostbin/go
RUN mkdir -p /ghostbin/go/src/github.com/DHowett \
    && git clone https://github.com/DHowett/spectre.git /ghostbin/go/src/github.com/DHowett/ghostbin \
    && cd /ghostbin/go/src/github.com/DHowett/ghostbin \
    #&& git checkout -b v1-stable \
    && echo "UPDATE PACKAGE.JSON" \
    && echo $'\
{\n\
  "name": "ghostbin",\n\
  "version": "0.0.1",\n\
  "description": "Spectre",\n\
  "main": "main.go",\n\
  "scripts": {\n\
    "test": "echo \\"Error: no test specified\\" && exit 1"\n\
  },\n\
  "repository": {\n\
    "type": "git",\n\
    "url": "git@git.howett.net:paste"\n\
  },\n\
  "author": "Dustin L. Howett <dustin@howett.net>",\n\
  "license": "GPL",\n\
  "dependencies": {\n\
    "grunt": "^1.4.1",\n\
    "grunt-cli": "^1.4.3",\n\
    "grunt-contrib-clean": "^2.0.0",\n\
    "grunt-contrib-concat": "^2.0.0",\n\
    "grunt-contrib-copy": "^1.0.0",\n\
    "grunt-contrib-cssmin": "^4.0.0",\n\
    "grunt-contrib-less": "^3.0.0",\n\
    "grunt-contrib-uglify": "^5.0.1",\n\
    "grunt-filerev": "^2.3.1",\n\
    "load-grunt-tasks": "^5.1.0"\n\
  }\n\
}\n\
    ' > package.json \
    && echo "========RESULT==========" \
    && cat -e package.json \
    && echo "========RESULT==========" \
# Change pygmentize path
    && sed -i -e 's:./bin/pygments/pygmentize:/usr/bin/pygmentize:g' languages.yml \
    && echo "Go get" \
    && go get \
    && echo "Go install" \
    && go install \
    && echo "Go build" \
    && go build \
    && npm install
WORKDIR /ghostbin/go/src/github.com/DHowett/ghostbin
USER root
RUN mkdir /logs \
    && chown -R ghostbin:ghostbin /logs \
    && mkdir /data \
    && chown -R ghostbin:ghostbin /data

EXPOSE 8619

VOLUME /logs
VOLUME /data

COPY ghostbin.sh /ghostbin/ghostbin.sh
# Ensure it's executable
RUN chmod +x /ghostbin/ghostbin.sh
ENTRYPOINT /ghostbin/ghostbin.sh
# CMD -addr="0.0.0.0:8619" -log_dir="/logs" -root="/data"
