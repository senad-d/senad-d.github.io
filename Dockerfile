FROM ruby

WORKDIR /usr/src/website
COPY . .
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle update --bundler
RUN bundle

RUN bundle install

CMD ["./tools/run"]