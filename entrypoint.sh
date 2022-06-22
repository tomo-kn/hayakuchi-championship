#!/bin/bash

sudo service nginx start
cd /myapp
bin/setup
bundle install --reinstall
bundle exec pumactl start
