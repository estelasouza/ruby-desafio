FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client && \
    apt-get update && curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs && npm install --global yarn
WORKDIR /myapp
COPY . /myapp
RUN gem update --system
RUN bundle install && gem install bundler --conservative && bundle check && yarn
CMD ["rails", "server"]