#!/usr/bin/env bash

sudo service nginx start
rm -f /myapp/tmp/pids/server.pid
cd /myapp
bin/setup
bundle exec pumactl start

