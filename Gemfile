source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }
gemspec
gem 'i18n'

group :development do
  gem 'fasterer'
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :test do
  gem 'rspec', '~> 3.8'
  gem 'rspec_junit_formatter'
  gem 'simplecov', require: false, group: :test
end
