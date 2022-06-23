#!/usr/bin/env bash

# アセットのプリコンパイル
bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=placeholder
yarn cache clean
rm -rf node_modules tmp/cache

service nginx start
rm -f /myapp/tmp/pids/server.pid
cd /myapp
bin/setup
bundle exec pumactl start
