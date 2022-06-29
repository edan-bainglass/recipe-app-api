#!/bin/sh

set -e

# genarates configuration file from template
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf

# starts nginx with generated configuration file
# ensures service is run in the foreground (when running in a Docker container)
nginx -g 'daemon off;'
