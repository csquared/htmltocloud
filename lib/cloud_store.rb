require 'digest/sha1'

class CloudStore
  def self.hash(*args)
    Digest::SHA1.hexdigest(args.join)
  end

  def self.name(user_id, url, type)
    "#{hash(user_id, url)}.#{format(type)}"
  end

  def self.format(type)
    (type == 'pdf') ? 'pdf' : 'jpg'
  end

  def self.connection
    CloudFiles::Connection.new(username: "csquared", 
                                api_key: "7d46b5defe0ab2a5207a36b189125dc8")
  end

  def initialize(user_id)
    @user_id    = user_id.to_s
  end

  def name(url, type)
    self.class.name(@user_id, url, type)
  end

  def hash(url)
    self.hash(@user_id, url)
  end

  def delete(hash, type)
    container.delete_object("#{hash}.#{self.class.format(type)}")
  end

  def public_url
    container.cdn_url
  end
  
  def connection
    @cloudfiles ||= self.class.connection
  end

  def provision
    connection.create_container(@user_id).tap do |c| 
      c.make_public
    end
    self
  end

  def upload_file(name, data)
    Timeout.timeout(120) do 
      object = container.create_object(name)
      object.write data
    end
  end

  def container
    connection.container(@user_id)
  end
end
