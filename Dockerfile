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
  sudo && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y yarn nodejs && \
  gem install bundler --update

RUN bundle install
COPY . /myapp
RUN yarn install --check-files

# コンテナ起動時に実行させるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 3000

# Railsサーバ起動
CMD ["rails", "server", "-b", "0.0.0.0"]