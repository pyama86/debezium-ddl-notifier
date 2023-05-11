FROM rubylang/ruby:3.2-dev-focal

WORKDIR /opt/app

COPY Gemfile      Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler -N
RUN bundle install -j4

COPY run.rb /opt/app/run.rb
CMD ["sh", "-c", "bundle exec ruby run.rb"]
