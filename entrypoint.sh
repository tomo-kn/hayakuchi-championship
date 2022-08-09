#!/usr/bin/env bash

# アセットのプリコンパイル
bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=placeholder
yarn cache clean
rm -rf node_modules tmp/cache

service nginx start
rm -f /myapp/tmp/pids/server.pid
cd /myapp

# DBの用意
bin/setup
bundle exec rake db:seed_fu
# sitemapの作成
bundle exec rake sitemap:refresh
# puma
bundle exec pumactl start