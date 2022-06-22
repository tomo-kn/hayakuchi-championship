#!/bin/bash

sudo service nginx start
cd /myapp
bin/setup
bundle exec puma -t 5:5 -p 3000 -e production -C config/puma.rb -d

