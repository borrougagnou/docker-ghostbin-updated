#!/bin/bash

### DOCKER LAUNCH
docker build -t borrougagnou/ghostbin-updated . 
docker run -it -d --name="ghostbin" -p 8619:8619 -v /var/log/ghostbin:/logs -v /var/data/ghostbin:/data borrougagnou/ghostbin-updated
