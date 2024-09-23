#!/bin/bash

set -e

echo "helloworld" > index.html
nohup busybox httpd -f -p "${server_port}" &