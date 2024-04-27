#!/bin/sh
if [ ! -f /data/expiry.gob ]; then
    touch /data/expiry.gob
    chown -R ghostbin:ghostbin /data
fi
sudo -E -u ghostbin /ghostbin/go/src/github.com/borrougagnou/ghostbin/ghostbin -addr="0.0.0.0:8619" -log_dir="/logs" -root="/data"
