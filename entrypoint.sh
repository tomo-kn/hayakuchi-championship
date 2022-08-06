#!/usr/bin/env bash

# アセットのプリコンパイル
bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=placeholder
yarn cache clean
rm -rf node_modules tmp/cache

service nginx start
rm -f /myapp/tmp/pids/server.pid
cd /myapp

# DBを強制的に削除したいときに使うコマンド(普段はコメントアウトしておく)
RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:drop

# DBの用意
bin/setup
bundle exec rake db:seed_fu
# puma
bundle exec pumactl start
