require 'spec_helper'

describe User, "::create(params = {})" do 
  context "without :container_url or 'container_url'" do 
    before do
      @mock_cloud = CloudStore
      mock(@mock_cloud).public_url { "http://www.example.com" } 
      mock(@mock_cloud).provision  { @mock_cloud } 
      stub(CloudStore).new(is_a(Fixnum)) { @mock_cloud }
    end

    it "should provision a Cloud account" do
      u = User.create
      u.container_url.should eql("http://www.example.com")
    end
  end

  context "with :container_url" do 
    before { dont_allow(CloudStore).new }
    it "should not provision the account" do
      u = User.create(:container_url => "test") 
      u.container_url.should eql("test")
    end
  end

  context "with 'container_url'" do 
    before { dont_allow(CloudStore).new }
    it "should not provision the account" do
      u = User.create('container_url'=> "test") 
      u.container_url.should eql("test")
    end
  end
end
