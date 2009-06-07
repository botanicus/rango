# encoding: utf-8

# HTTP 200
Then "it should respond successfuly" do
  @response.should be_successful
end

# not HTTP 200
Then "the (.*) ?request should fail" do |_|
  @response.should_not be_successful
end

# HTTP 404, 406, 500
Then /it should have status (\d{3})/ do |status|
  @response.status.should eql(status.to_i)
end

Then /^(\w+) should be redirected to "(.+)"$/ do |who, uri|
  @response.should redirect_to(uri)
end

# content type
Then /it should render page in (\w+) format/ do |format|
  @response.should have_content_type(format.to_sym)
end

# have given content
Then /^I should see "(.*)"$/ do |text|
  #@response.body.to_s.should =~ /#{text}/m
  @response.body.should have_content(text)
end

# have not given content
Then /^I should not see "(.*)"$/ do |text|
  @response.body.to_s.should_not =~ /#{text}/m
end

# have given message
Then /^I should see an? (\w+) message$/ do |message_type|
  @response.should have_xpath("//*[@class='#{message_type}']")
end
