require 'uri'
require 'securerandom'

class User
  include DataMapper::Resource

  property :id, Serial
  property :email, String, :length => (5..40), :unique => true, :format => :email_address
  property :identifier, String, :length => (0..255)
  property :username, String
  property :raw_profile, Text
  property :created_at, Time
  property :container_url, String, :length => (0..255)
  property :total_imgs, Integer, :default => 0
  property :total_pdfs, Integer, :default => 0
  property :api_key, String, :length => (10..100), 
      :default => lambda { |r,p| SecureRandom.hex(10) }

  has n, :histories

  def self.from_profile(profile)
    raise "No identifier in profile" unless profile['identifier']
    User.first(identifier: profile['identifier']) ||
    User.create(email: profile['email'], identifier: profile['identifier'],
                username: profile['preferredUsername'], raw_profile: profile)
  end

  def self.create(args = {})
    user = super args
    unless user.container_url
      user.container_url = CloudStore.new(user.id).provision.public_url
      user.save
    end
    user
  end

  def increment(type)
    total = send("total_#{type}s")
    send("total_#{type}s=",total+1)
  end

  def created(source, type)
    histories << History.create(source: source, type: type, 
                                  created_at: Time.now,
                                  hosted_url: public_url(source, type))
    increment(type)
    save
  end

  def auth_url
    if ENV['RACK_ENV'] == 'production' 
      scheme, home = 'https', 'htmltocloud.com'
    else
      scheme, home = 'http', 'localhost:4567'
    end
    "#{scheme}://#{id}:#{api_key}@#{home}/"
  end

  def public_url(source, type)
    URI.join(@container_url, CloudStore.name(id, source, type))
  end
end
