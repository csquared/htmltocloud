ENV['RACK_ENV'] ||= 'development'

#run lambda { |env| [200,{},["DB URL: #{ENV['DATABASE_URL']}"]] }
require File.expand_path('../lib/app', __FILE__)

require 'resque/server'
run Rack::URLMap.new \
    "/"       => HtmlToCloud,
    "/resque" => Resque::Server.new
