#!/usr/bin/env bash

rm -f /myapp/tmp/pids/server.pid
cd /myapp
bin/setup
bundle exec pumactl start

