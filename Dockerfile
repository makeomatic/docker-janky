FROM ruby:2.3.1-alpine

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# cache gems
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN \
  apk add --no-cache --virtual .buildDeps \
    g++ \
    make \
    libstdc++ \
    mysql-client \
    git \
  && bundle install --path vendor/gems --binstubs \
  && apk add --no-cache --virtual .runDeps \
    libstdc++ \
    mysql-client \
  && apk del .buildDeps

# copy code
COPY . /usr/src/app

# port + start
EXPOSE 8080
CMD ["bundle", "exec", "thin", "start", "-p", "8080"]
