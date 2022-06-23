#!/usr/bin/env bash

# アセットのプリコンパイル
RUN bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=placeholder
RUN yarn cache clean
RUN rm -rf node_modules tmp/cache

service nginx start
rm -f /myapp/tmp/pids/server.pid
cd /myapp
bin/setup
bundle exec pumactl start
