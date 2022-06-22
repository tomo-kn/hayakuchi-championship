#!/usr/bin/env bash
set -e

sudo service nginx start

bundle exec pumactl start

exec "$@"