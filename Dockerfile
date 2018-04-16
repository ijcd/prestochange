# https://elixirforum.com/t/smallest-docker-container-with-elixir-app/6975/24

###############################
# Build Stage
###############################

FROM elixir:1.6-slim as builder

# build packages
RUN echo 'deb http://httpredir.debian.org/debian jessie-backports main contrib non-free' >> /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qq install --no-install-recommends \
      build-essential \
      ca-certificates \
      git \
      apt-transport-https \
      aptitude \
      curl \
      nodejs \
      libsass0 \
      rebar

# for yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get -qq update
RUN aptitude -t jessie-backports --without-recommends -y install nodejs yarn
RUN ln -s /usr/bin/nodejs /usr/bin/node

# setup hex/rebar
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix hex.info

#################
# Begin App Build
#################

WORKDIR /app
ENV MIX_ENV=prod

# add and build deps
ADD mix.* ./
RUN mix deps.get
RUN mix deps.compile

# add and build assets
ADD priv priv
ADD assets assets
RUN cd assets && yarn
#RUN cd assets && ./node_modules/brunch/bin/brunch build --production
RUN cd assets && ./node_modules/brunch/bin/brunch build
RUN mix phx.digest

# add the rest
ADD . .

# build release
RUN mix release --env=$MIX_ENV --verbose

# unpack into /final
RUN mkdir /final && cd /final && tar -zxvf /app/_build/prod/rel/presto_change/releases/0.0.1/presto_change.tar.gz


###############################
# Release Stage
###############################

FROM debian:jessie-slim
RUN apt-get -qq update && \
    apt-get -qq install --no-install-recommends \
      locales \
      libssl1.0.0 \
      curl \
    && rm -rf /var/lib/apt/lists/*

# setup locales
RUN echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen && \
    ln -s /etc/locale.alias /usr/share/locale/locale.alias && \
    locale-gen

ENV LANG="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

#################
# Begin App Setup
#################

WORKDIR /app

COPY --from=builder /final .
# COPY --from=builder /app/rel/scripts/boot.sh ./bin

EXPOSE 5000

ENV MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    PORT=5000

# USER nobody

# CMD ["./bin/boot.sh", "foreground"]
CMD ["./bin/presto_change", "foreground"]
