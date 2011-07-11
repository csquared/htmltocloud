require 'spec_helper'

describe Service::IMG do 
  include Rack::Test::Methods

  def app
    Service::IMG
  end

  it "should return 401 for no auth" do
    post '/img'
    last_response.status.should eql(401)
  end

  it "should return 401 for bad auth" do 
    authorize 'bad', 'boy'
    post '/img'
    last_response.status.should eql(401)
  end

  context "with a good user" do
    before do
      @user = User.create('identifier' => "test", 
                          'username' => "test", 
                          'container_url' => 'http://www.example.com')
    end

    it "should allow posting" do
      stub(Resque).enqueue(Workers::CreateIMG, @user.id, 'http://www.google.com')
      authorize @user.id, @user.api_key
      post '/img', :url => 'http://www.google.com'
      last_response.status.should eql(200)
    end

    it "should create the name from the public url and the SHA1 of id + url" do
      stub(Resque).enqueue
      authorize @user.id, @user.api_key
      post '/img', :url => 'http://www.google.com'
      sha1 = Digest::SHA1.hexdigest([@user.id,'http://www.google.com'].join)
      last_response.body.should eql("http://www.example.com/#{sha1}.jpg")
    end

    it "should not allow unknown variables" do
      dont_allow(Resque).enqueue
      post '/img', :poop => 'http://www.google.com'
      last_response.status.should_not eql(200)
    end
  end
end

describe Service::PDF do 
  include Rack::Test::Methods

  def app
    Service::PDF
  end

  it "should return 401 for no auth" do
    post '/pdf'
    last_response.status.should eql(401)
  end

  it "should return 41 for bad auth" do 
    authorize 'bad', 'boy'
    post '/pdf'
    last_response.status.should eql(401)
  end

  context "with a good user" do
    before do
      @user = User.create('identifier' => "test", 
                          'username' => "test", 
                          :container_url => 'http://www.example.com')
    end

    it "should allow posting" do
      stub(Resque).enqueue
      authorize @user.id, @user.api_key
      post '/pdf', :url => 'http://www.google.com'
      last_response.status.should eql(200)
    end

    it "should create the name from the public url and the SHA1 of id + url" do
      stub(Resque).enqueue(Workers::CreatePDF, @user.id, 'http://www.google.com')
      authorize @user.id, @user.api_key
      post '/pdf', :url => 'http://www.google.com'
      sha1 = Digest::SHA1.hexdigest([@user.id,'http://www.google.com'].join)
      last_response.body.should eql("http://www.example.com/#{sha1}.pdf")
    end

    it "should not allow unknown variables" do
      dont_allow(Resque).enqueue
      post '/pdf', :poop => 'http://www.google.com'
      last_response.status.should_not eql(200)
    end
  end
end

