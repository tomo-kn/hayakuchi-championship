FROM ruby:3.1.2

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
# debconf: delaying package configuration, since apt-utils is not installedを非表示
# ENV DEBCONF_NOWARNINGS=yes

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile

# yarnパッケージ管理ツールをインストール
RUN apt-get update && \
  apt-get install -y build-essential \
  curl apt-transport-https wget \
  libpq-dev \
  nginx \
  sudo && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y yarn nodejs && \
  gem install bundler --update

RUN gem update --system

RUN yarn install --check-files
RUN bundle install

# アセットのプリコンパイル
RUN bundle exec rails assets:precompile RAILS_ENV=production SECRET_KEY_BASE=placeholder WEBPACKER_PRECOMPILE=false
RUN yarn cache clean
RUN rm -rf node_modules tmp/cache

COPY . /myapp
RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids

# nginx
RUN groupadd nginx
RUN useradd -g nginx nginx
ADD nginx/nginx.conf /etc/nginx/nginx.conf

# コンテナ起動時に実行させるスクリプトを追加
EXPOSE 80
RUN chmod +x /myapp/entrypoint.sh
ENTRYPOINT [ "sh", "/myapp/entrypoint.sh" ]