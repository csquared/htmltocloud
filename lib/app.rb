ENV['RACK_ENV'] ||= 'development'
puts "Loading #{ENV['RACK_ENV']}"
require 'digest/sha1'
require 'bundler'
Bundler.require :default, ENV['RACK_ENV'] 
$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

#connect to DB
SESSION_SECRET = ENV['SESSION_SECRET'] || File.read(File.expand_path('../../config/sesssion', __FILE__))
APP_ROOT = File.expand_path('../../', __FILE__)
require 'cloud_store'
require 'workers'
require 'janrain'
require 'models/user'
require 'models/history'
require 'app/heroku_add_on'
require 'app/service'
require 'app/frontend'

DB_CONFIG = Crack::JSON.parse(File.read(File.expand_path'../../config/database.json', __FILE__)) rescue {}
DataMapper.setup(:default, ENV['DATABASE_URL'] || DB_CONFIG[ENV['RACK_ENV']])
HtmlToCloud = Rack::Cascade.new([FrontEnd, Service::PDF, Service::IMG, Service::HerokuAddOn], [404, 401])

ENV["REDISTOGO_URL"] ||= "redis://localhost:6379/"

uri = URI.parse(ENV["REDISTOGO_URL"])
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

Janrain.instance_eval do
  default_params apiKey: ENV['JANRAIN_KEY']
end

