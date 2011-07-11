class History
  include DataMapper::Resource
  
  property :id, Serial
  property :source, Text
  property :hosted_url, String, :length => (5..255)
  property :created_at, DateTime
  property :type, String, :length => (2..10)

  belongs_to :user
end
