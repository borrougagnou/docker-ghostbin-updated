FROM golang:1.17.7-alpine3.15

RUN apk add --update \
    git \
    py-pygments \
    sudo \
    nodejs npm && npm install npm@latest -g \
    && rm -rf /var/cache/apk/* \
    && adduser -h /ghostbin -u 10000 -D -g "" ghostbin
USER ghostbin
ENV GOPATH=/ghostbin/go
RUN mkdir -p /ghostbin/go/src/github.com/borrougagnou \
    && git clone https://github.com/borrougagnou/spectre-updated.git /ghostbin/go/src/github.com/borrougagnou/ghostbin \
    && cd /ghostbin/go/src/github.com/borrougagnou/ghostbin \
    && sed -i -e 's:./bin/pygments/pygmentize:/usr/bin/pygmentize:g' languages.yml \
    && echo "Go get" \
    && go get \
    && echo "Go install" \
    && go install \
    && echo "Go build" \
    && go build \
    && npm install
WORKDIR /ghostbin/go/src/github.com/borrougagnou/ghostbin
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
