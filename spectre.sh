#!/bin/sh
if [ ! -f /data/expiry.gob ]; then
    touch /data/expiry.gob
    chown -R spectre:spectre /data
fi
sudo -E -u spectre /spectre/go/src/github.com/borrougagnou/spectre-updated/spectre-updated -addr="0.0.0.0:8619" -log_dir="/logs" -root="/data"
