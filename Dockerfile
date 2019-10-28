FROM ruby:2.6.5

RUN gem install bundler -v 2.0.2

WORKDIR /usr/src/app

COPY Gemfile fast_matrix.gemspec ./
COPY lib/fast_matrix ./lib/fast_matrix
RUN bundle install

COPY Rakefile ./
COPY ext/ ./ext
RUN rake compile

COPY . .
RUN rake test

CMD rake test TESTOPTS='-v'