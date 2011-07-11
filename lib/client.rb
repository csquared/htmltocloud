require 'uri'
require 'httparty'

$URI = URI.parse(ENV['HTML2CLOUD_URL'])

class Html2Cloud
  include HTTParty
  base_uri "#{$URI.scheme}://#{$URI.host}:#{$URI.port}"
  basic_auth $URI.user, $URI.password
end

begin
  ['/img', '/pdf'].each do |type| 
    response = Html2Cloud.post(type, {body: {url: 'http://www.reddit.com'}})
    response = Html2Cloud.post(type, {body: {html: '<h1>Hello, world! K^2</h1>'}})
    raise "#{response.code} response" unless response.code == 200
  end
rescue => e
  abort "Failed to generate image #{e.message}"
end
