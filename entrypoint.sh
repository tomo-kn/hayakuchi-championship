#!/usr/bin/env bash
set -e

sudo sh -c 'echo 127.0.0.1 $(hostname) >> /etc/hosts'
sudo service nginx start
cd /myapp
bin/setup
bundle exec pumactl start

exec "$@"