#!/bin/bash

### DOCKER LAUNCH
docker build -t borrougagnou/spectre-updated . 
docker run -it -d --name="spectre" -p 8619:8619 -v /var/log/spectre:/logs -v /var/data/spectre:/data borrougagnou/spectre-updated
