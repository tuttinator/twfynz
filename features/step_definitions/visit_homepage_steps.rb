Given /^I am a user$/ do
  User.new
end

When /^I visit the site$/ do
  visit root_path
end

Then /^I should see the homepage$/ do
  page.should have_content("Home")
end
