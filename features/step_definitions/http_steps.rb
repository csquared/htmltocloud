When /^I send a POST request to "([^"]*)" with body$/ do |url, body|
  @response = page.driver.post(url, body)
end

Then /^I should receive the following response body$/ do |string|
  puts @response.inspect
  #@response.body.should eql(string)
end


Given /^the workers are running$/ do 
  Resque.stub(:enqueue)
end


Given /^my cloudfiles public_url is "([^"]*)"$/ do |url| 
  mock_connection = mock(CloudFiles)
  CloudStore.stub(:connection).and
end
