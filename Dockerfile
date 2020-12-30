FROM ruby:2.7

# throw errors if Gemfile has been modified since Gemfile.lock
WORKDIR /the_oracle

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
