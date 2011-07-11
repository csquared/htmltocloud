When /^I sign in through Janrain as "([^"]*)"$/ do |username|
  Janrain.stub(:auth_info).and_return({'profile' => 
    {'email' => 'a@example.com', 'identifier' => 'http://im.a.dick.com', 
    'preferredUsername' => 'tits.mcgee'}
  })
  page.driver.post('/login')
  visit('/account')
end

Given /^I expect the user to be provisioned$/ do
  @mock_cloud = mock(CloudStore)
  CloudStore.stub(:new).and_return(@mock_cloud)
  @mock_cloud.should_receive(:public_url).and_return("http://www.example.com")
  @mock_cloud.should_receive(:provision).and_return(@mock_cloud)
end

Given /^I have an account as "([^"]*)"$/ do |name|
  Given "I expect the user to be provisioned"
  @user = User.create(username: name, identifier: "http://im.a.dick.com", email: "a@example.com") 
end

Given /^my "([^"]*)" is "([^"]*)"$/ do |method, value|
  @user.send("#{method}=", value) 
  @user.save!
end
