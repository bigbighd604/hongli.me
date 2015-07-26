#!/bin/bash

NGINX=/usr/local/openresty/nginx/sbin/nginx
CWD=$(pwd)
DIR=$(dirname $0)

# Run as ./start_nginx.sh
if [[ "$DIR" == "." ]]; then
	DIR="$CWD"
# Run as the followings:
# $./www/start_nginx.sh
# $../www/start_nginx.sh
elif [[ ! "$DIR" =~ ^/ ]]; then
	DIR="$CWD/$DIR"
fi
# If not run as the above 2 cases, it's run as full path.
echo $DIR

# Change current working directory to under 'www', this will be
# the cwd of nginx process. And also the relative path in lua code
# will be started as this directory. i.e
# local file = io.open("html/index.html") 
# it will try to open /local/path/to/www/html/index.html
cd $DIR

# Create logs folder, otherwise nginx start will fail.
mkdir -p logs
$NGINX -p "$DIR"
