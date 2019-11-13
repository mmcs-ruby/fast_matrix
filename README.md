|Gem|Activity|Code|Issue|Statistic|
|--:|--:|--:|--:|--:|
|![Gem](https://img.shields.io/gem/v/fast_matrix?color=light)|![GitHub last commit](https://img.shields.io/github/last-commit/mmcs-ruby/fast_matrix)|[![Build Status](https://travis-ci.org/mmcs-ruby/fast_matrix.svg?branch=master)](https://travis-ci.org/mmcs-ruby/fast_matrix)|![GitHub issues](https://img.shields.io/github/issues-raw/mmcs-ruby/fast_matrix)|[![Top language](https://img.shields.io/github/languages/top/mmcs-ruby/fast_matrix.svg)](https://img.shields.io/github/languages/top/mmcs-ruby/fast_matrix.svg)
|[![Downloads](https://img.shields.io/gem/dt/fast_matrix.svg)]((https://img.shields.io/gem/dt/fast_matrix.svg))|![GitHub commits since tagged version](https://img.shields.io/github/commits-since/mmcs-ruby/fast_matrix/v0.2.0/develop?color=light)|[![Maintainability](https://api.codeclimate.com/v1/badges/fd171bae2ca444aaca29/maintainability)](https://codeclimate.com/github/mmcs-ruby/fast_matrix/maintainability)|![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/mmcs-ruby/fast_matrix)|[![Languages](https://img.shields.io/github/languages/count/mmcs-ruby/fast_matrix.svg)](https://img.shields.io/github/languages/count/mmcs-ruby/fast_matrix.svg)
|[![Downloads Latest](https://img.shields.io/gem/dtv/fast_matrix.svg)](https://badge.fury.io/rb/fast_matrix.svg)|![GitHub commit activity](https://img.shields.io/github/commit-activity/m/mmcs-ruby/fast_matrix?color=light)|[![Test Coverage](https://api.codeclimate.com/v1/badges/fd171bae2ca444aaca29/test_coverage)](https://codeclimate.com/github/mmcs-ruby/fast_matrix/test_coverage)|![GitHub issues by-label](https://img.shields.io/github/issues-raw/mmcs-ruby/fast_matrix/bug)|![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/mmcs-ruby/fast_matrix)

# FastMatrix

Ruby wrapper around C matrices implementation written as exercise by MMCS students.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast_matrix'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fast_matrix

## Usage and documentation

See our [GitHub Wiki](https://github.com/mmcs-ruby/fast_matrix/wiki).

## Development

Fast matrix is native extension in C, so, for development you need Linux (maybe, MacOS) or Docker.

After checking out the repo, run `gem install bundler -v 2.0.2`, `bundle install` and `bundler exec rake` or use `Dockerfile`.

Commands:
  + `bundler exec rake compile` - compile C part of gem;
  + `bundler exec rake test` - run tests;
  + `bundler exec rake test TESTOPTS='-v'` - run tests with more information (description skipped tests);
  + `bundler exec rake` - compile and run tests.


To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mmcs-ruby/fast_matrix. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FastMatrix project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mmcs-ruby/fast_matrix/blob/master/CODE_OF_CONDUCT.md).
