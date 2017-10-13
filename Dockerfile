FROM ruby:2.3

USER root

ENV BUNDLER_VERSION 1.15.1

# en - English
# pt - Portuguese and Brazilian Portuguese
# es - Spanish
# pl - Polish
ENV ASPELL_LANGUAGES aspell-en aspell-pt aspell-es aspell-pl

# JavaScript runtime required by execjs gem
# Spellchecking
ENV PACKAGES nodejs aspell $ASPELL_LANGUAGES

RUN apt-get update && apt-get -y install $PACKAGES

# Fix the Bundler version
RUN gem install bundler -v $BUNDLER_VERSION
RUN mkdir /guides

WORKDIR /guides

ADD Gemfile /guides/Gemfile
ADD Gemfile.lock /guides/Gemfile.lock
RUN bundle install

ADD . /guides

CMD bundle exec middleman
