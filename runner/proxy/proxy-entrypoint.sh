#!/usr/bin/env sh

set -evx

#autossh -f \
#    -o StrictHostKeyChecking=no \
#    -N \
#    -R 443:nginx:443 \
#    -R 5432:nginx:5432 \
#    "$@"
autossh -M 0 -N \
    -o "ServerAliveInterval 60" \
    -o "ServerAliveCountMax 3" \
    -R 80:nginx:80 \
    -R 443:nginx:443 \
    -R 5432:nginx:5432 \
    "$@"
