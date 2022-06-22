#!/bin/sh

sudo service nginx start
cd /myapp
bin/setup
bundle exec pumactl start

