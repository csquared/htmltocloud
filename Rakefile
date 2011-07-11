require File.expand_path('../lib/app', __FILE__)
require 'resque/tasks'

namespace :db do
  desc 'Auto-migrate the database (destroys data)'
  task :migrate do
    DataMapper.auto_upgrade!
  end

  desc 'Auto-upgrade the database (preserves data)'
  task :reload do
    DataMapper.auto_migrate!
  end
end
