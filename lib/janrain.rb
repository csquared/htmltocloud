class Janrain
  include HTTParty
  format :json
  base_uri 'https://rpxnow.com/api/v2/'

  def self.auth_info(token)
    self.get("/auth_info", query: { token: token })
  end
end
