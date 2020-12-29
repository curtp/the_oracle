FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /discord_bot

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
