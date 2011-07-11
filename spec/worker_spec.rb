require 'spec_helper'

describe Workers::CreateIMG, '::perform(user_id, source)' do
  before do
    @user   = User.create(:container_url => "http://www.example.com")
    @source = "<test>"
    @imgkit = IMGKit
    mock(@imgkit).to_img { "BINARY DATA" }
    mock(IMGKit).new(@source) { @imgkit } 
    @cloud_store = CloudStore.dup
    mock(CloudStore).new(@user.id) { @cloud_store }
    stub(@cloud_store).upload_file
    stub(@cloud_store).name
  end

  it "should call IMGKit with source and upload to user's CloudStore" do
    Workers::CreateIMG.perform(@user.id, @source)
  end

  it "should create a history entry for the user" do
    Workers::CreateIMG.perform(@user.id, @source)
    User.get(@user.id).should have(1).histories
  end
end
