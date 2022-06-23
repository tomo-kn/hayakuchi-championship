#!/usr/bin/env bash

service nginx start
rm -f /myapp/tmp/pids/server.pid
cd /myapp
bin/setup
bundle exec pumactl start

bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=placeholder

service nginx restart
bundle exec pumactl restart