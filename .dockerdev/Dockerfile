FROM node:12.15.0-alpine as node

FROM ruby:2.7.1-alpine as dev

ARG BUNDLER_VERSION="2.1.4"

ENV LANG C.UTF-8
ENV APP_HOME /app_home

RUN mkdir ${APP_HOME}
WORKDIR ${APP_HOME}

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

# install dependencies
RUN apk --update --no-cache add shadow sudo busybox-suid mariadb-connector-c-dev tzdata alpine-sdk less imagemagick

# copy nodejs and yarn
COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt/yarn-v1.21.1 /opt/yarn

RUN ln -s /usr/local/bin/node /usr/local/bin/nodejs && \
    ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn

RUN gem update --system && \
    gem install bundler --version ${BUNDLER_VERSION} && \
    bundle install


FROM dev as builder

COPY . .
RUN mkdir -p ${APP_HOME}/public/assets && mkdir -p ${APP_HOME}/public/packs
RUN yarn install
RUN RAILS_ENV=production bundle exec rails assets:precompile


FROM ruby:2.7.1-alpine as production

# install dependencies
RUN apk --update --no-cache add shadow sudo busybox-suid execline tzdata mariadb-connector-c-dev imagemagick && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

EXPOSE 3000

ENV LANG C.UTF-8
ENV APP_HOME /app_home

RUN mkdir ${APP_HOME}
WORKDIR ${APP_HOME}

COPY . .

# gemやassets:precompileの終わったファイルはbuilderからコピーしてくる
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder ${APP_HOME}/public/assets/ ${APP_HOME}/public/assets/
COPY --from=builder ${APP_HOME}/public/packs/ ${APP_HOME}/public/packs/

CMD ["rails", "server", "-b", "0.0.0.0"]