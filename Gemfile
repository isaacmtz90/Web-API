source 'https://rubygems.org'
ruby '2.3.1'

gem 'sinatra'
gem 'puma'
gem 'json'
gem 'econfig'
gem 'rake'
gem 'http'
gem 'sequel'

gem 'meetupevents'
gem 'sequel'
gem 'roar'
gem 'dry-monads'
gem 'dry-container'
gem 'dry-transaction'

group :development, :test do
  gem 'sqlite3'
end

group :development do
  gem 'flog'
  gem 'flay'
  gem 'rerun'
end
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'pg'
end

group :development, :production do
  gem 'tux'
  gem 'hirb'
end
