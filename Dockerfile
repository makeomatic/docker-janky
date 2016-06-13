FROM makeomatic/ruby:v2.3.1

RUN bundle config --global frozen 1 \
    && mkdir -p /usr/src/app

WORKDIR /usr/src/app

# cache gems
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN \
  apk add --no-cache --virtual .buildDeps \
    g++ \
    make \
    libstdc++ \
    mariadb-dev \
    git \
    openssl \
    ca-certificates \
  && bundle install --path vendor/gems --binstubs \
  && apk add --no-cache --virtual .runDeps \
    libstdc++ \
    mariadb-client-libs \
    openssl \
    ca-certificates \
  && apk del .buildDeps

# copy code
COPY . /usr/src/app
RUN \
    chown -R ruby:ruby /usr/src/app \
    && chmod +x ./entrypoint.sh

USER ruby

# port + start
EXPOSE 8080
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]
CMD ["thin", "-p", "8080", "start"]
