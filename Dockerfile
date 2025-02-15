FROM golang:1.24-alpine3.21

RUN apk add --update \
    git \
    py-pygments \
    sudo \
    nodejs npm && npm install npm@latest -g \
    && rm -rf /var/cache/apk/* \
    && adduser -h /spectre -u 10000 -D -g "" spectre
USER spectre
ENV GOPATH=/spectre/go
RUN mkdir -p /spectre/go/src/github.com/borrougagnou \
    && git clone -b stable https://github.com/borrougagnou/spectre-updated.git /spectre/go/src/github.com/borrougagnou/spectre-updated \
    && cd /spectre/go/src/github.com/borrougagnou/spectre-updated \
    && sed -i -e 's:pygmentize:/usr/bin/pygmentize:g' languages.yml \
    && echo "Go get" \
    && go get \
    && echo "Go install" \
    && go install \
    && echo "Go build" \
    && go build \
    && npm install
WORKDIR /spectre/go/src/github.com/borrougagnou/spectre-updated
USER root
RUN mkdir /logs \
    && chown -R spectre:spectre /logs \
    && mkdir /data \
    && chown -R spectre:spectre /data

EXPOSE 8619

VOLUME /logs
VOLUME /data

COPY spectre.sh /spectre/spectre.sh
# Ensure it's executable
RUN chmod +x /spectre/spectre.sh
ENTRYPOINT [ "/spectre/spectre.sh" ]
# CMD -addr="0.0.0.0:8619" -log_dir="/logs" -root="/data"
