# encoding: utf-8

# Roles:
#   - user (general user)
#   - admin (authenticated user)
#   - customer ()
#   - guest ()

# request
# use it just for /admin, /login and /
# in other cases use "click to"
# THIS CONFLICT WITH SOME STUFF IN EXCEPTIONS FEATURE
#When /^\w+ goes to (.+)$/ do |uri|
#  @response = request(uri)
#end

# Commonly used webrat steps
# http://github.com/brynary/webrat
When /^(\w+) goes to "(.+)"$/ do |user, path|
  @response = visit(path)
end

When /^I press "(.*)"$/ do |button|
  click_button(button)
end

# "user click to" or "admin click to"
When /^\w+ click to "(.*)"$/ do |link|
  @response = click_link(link)
end

When /^I fill in "(.*)" with "(.*)"$/ do |field, value|
  fill_in(field, with: value)
end

When /^I select "(.*)" from "(.*)"$/ do |value, field|
  select(value, from: field)
end

When /^I check "(.*)"$/ do |field|
  check(field)
end

When /^I uncheck "(.*)"$/ do |field|
  uncheck(field)
end

When /^I choose "(.*)"$/ do |field|
  choose(field)
end

When /^I attach the file at "(.*)" to "(.*)" $/ do |path, field|
  attach_file(field, path)
end
