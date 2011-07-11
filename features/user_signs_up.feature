Feature:
  In order to use HtmlToCloud 
  As a customer
  I need an easy to use home page

Scenario: API is documented on home page
  When I go to "the home page"
  Then I should see "POST /img"
  And I should see "POST /pdf"

Scenario: I can sign up from the home page
  Given I go to "the home page"
  And I expect the user to be provisioned
  When I sign in through Janrain as "tits.mcgee"
  Then I should see "tits.mcgee"

Scenario: User gets api access
  Given I have an account as "tits.mcgee"
  And my "api_key" is "123456789"
  And my "id" is "42"
  When I sign in through Janrain as "tits.mcgee"
  Then I should see "You have generated 0 images and 0 pdfs"
  When I follow "API" 
  Then I should see "http://42:123456789@htmltocloud.com"
  And I should see "HTTParty"
  And I should see "base_uri 'http://htmltocloud.com'"
  And I should see "basic_auth '42', '123456789'"
