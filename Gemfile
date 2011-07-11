source 'http://rubygems.org'
gem 'sinatra', :require => "sinatra/base"
gem 'imgkit'
gem 'json' 
gem 'resque'
gem 'pdfkit'
gem 'dm-core', '1.1.0'
gem 'data_objects', '0.10.3'
gem 'dm-migrations'
gem 'dm-validations'
gem 'dm-transactions'
gem 'dm-timestamps'
gem 'haml'
gem 'rack-flash'
gem 'httparty'
gem 'cloudfiles'
gem 'heroku', :require => false
gem 'rack-test'
gem "compass"
gem "rvm"
gem 'thin'
gem 'foreman'

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
  gem 'do_postgres', '0.10.3'
end

group :development do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
  gem 'do_sqlite3', '0.10.3'
  #gem 'do_mysql', '0.10.3'
  #gem 'dm-mysql-adapter'
  #gem 'compass'
end

group :test do
  gem 'ruby-debug19' #, :git => "https://github.com/mark-moseley/ruby-debug.git"
  gem 'rspec', '~> 2'
  gem 'capybara'
  gem 'cucumber'
  gem 'cucumber-sinatra'
  gem 'database_cleaner'
  gem 'rr'
end
