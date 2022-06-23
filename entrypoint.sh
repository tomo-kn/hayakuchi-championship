#!/usr/bin/env bash

systemctl start nginx
rm -f /myapp/tmp/pids/server.pid
cd /myapp
bin/setup
bundle exec pumactl start

