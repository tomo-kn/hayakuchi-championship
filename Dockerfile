FROM ruby:3.1.2

ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
# debconf: delaying package configuration, since apt-utils is not installedを非表示
ENV DEBCONF_NOWARNINGS=yes

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


RUN yarn install --check-files
RUN bundle install
COPY . /myapp
RUN mkdir -p tmp/sockets
RUN mkdir -p tmp/pids

# nginx
RUN groupadd nginx
RUN useradd -g nginx nginx
ADD nginx/nginx.conf /etc/nginx/nginx.conf

# コンテナ起動時に実行させるスクリプトを追加
EXPOSE 80
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
CMD ["/usr/bin/entrypoint.sh"]