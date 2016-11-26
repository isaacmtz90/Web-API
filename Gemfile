source 'https://rubygems.org'
ruby '2.3.1'

gem 'sinatra'
gem 'puma'
gem 'json'
gem 'econfig'
gem 'http'
gem 'sequel'

# refactoring gems
gem 'roar'
gem 'multi_json'
gem 'dry-monads'
gem 'dry-container'
gem 'dry-transaction'

gem 'meetupevents'

group :development, :test do
  gem 'pry-byebug'
  gem 'rerun'
  gem 'sqlite3'
end

group :development do
  gem 'flog'
  gem 'flay'
end

group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack-test'
  gem 'rake'
  gem 'vcr'
  gem 'webmock'
end

group :development, :production do
  gem 'tux'
  gem 'hirb'
end

group :production do
  gem 'pg'
end
