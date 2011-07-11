ENV['RACK_ENV'] = 'test'
require File.expand_path('../../lib/app', __FILE__)
require 'rack/test'

RSpec.configure do |config|
  config.mock_with :rr
end

