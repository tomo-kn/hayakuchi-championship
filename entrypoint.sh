#!/usr/bin/env bash

service nginx start
rm -f /myapp/tmp/pids/server.pid
cd /myapp
bin/setup
bundle exec pumactl start

