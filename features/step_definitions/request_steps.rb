def select_supply(supply = "Gauze")
  select supply, from: "order_supply_id"
end

When(/^I place a request$/) do
  visit '/orders/new'
end

When(/^I give it all inputs but "(.*?)"$/) do |field|
  fill_in "Location", :with => "loc but arg"
  fill_in "Units",    :with => "mg"
  fill_in "Quantity", :with => "1"
  fill_in "Special instructions area",  :with => "S/I/A but"
  case field
  when "Select Supply"
    # Do nothing for "Select Supply"
  end
  click_button "Submit"
end

When(/^I give it all inputs but location$/) do
  # FYI: Do nothing for "Locaton"
  fill_in "Units",    :with => "mg"
  fill_in "Quantity", :with => "1"
  fill_in "Special instructions area",  :with => "S/I/A location"
  select_supply
  click_button "Submit"
end

When(/^I give it all inputs but quantity$/) do
  fill_in "Location", :with => "loc but quantity"
  fill_in "Units",    :with => "mg"
  # FYI: Do nothing for "Quantity"
  fill_in "Special instructions area",  :with => "S/I/A qty"
  select_supply
  click_button "Submit"
end

When(/^I give it all inputs but units$/) do
  fill_in "Location", :with => "loc but units"
  # FYI: Do nothing for "Units"
  fill_in "Quantity", :with => "1"
  fill_in "Special instructions area",  :with => "S/I/A but units"
  select_supply
  click_button "Submit"
end

When(/^I give it all the valid inputs$/) do
  fill_in "Location", :with => "loc valid inputs"
  fill_in "Units",    :with => "mg"
  fill_in "Quantity", :with => "1"
  fill_in "Special instructions area", :with => "S/I/A valid"
  select_supply
  click_button "Submit"
end

When(/^I give it all inputs with non\-number "(.*?)"$/) do |field|
  fill_in "Location", :with => "loc valid inputs"
  fill_in "Units",    :with => "mg"
  if (field == "Quantity")
    fill_in "Quantity", :with => "BADVALUE" #WRONG
  else
    fill_in "Quantity", :with => "1"
  end
  fill_in "Special instructions area", :with => "S/I/A valid"
  select_supply
  click_button "Submit"
end

#P9 (SUCCESS)
Then(/^I see a successful request message$/) do
  page.should have_selector ".alert", text: /Success! The Order you placed on behalf of .* has been sent./
end

# ERRORS
Then(/^I see a invalid supply request message$/) do
  page.should have_content "shortcode unrecognized"
end

Then(/^I see a invalid quantity request message$/) do
  page.should have_content "Quantity is missing"
end

Then(/^I see a invalid units request message$/) do
  page.should have_content "Unit is missing"
end

Then(/^I see a nonnumber quantity request message$/) do
  page.should have_content "Quantity is not a number"
end

Then(/^I see an invalid "(.*?)" request message$/) do |field|
  page.should have_content "#{field} is missing"
end

Then(/^I see a nonnumber "(.*?)" request message$/) do |field|
  page.should have_content "#{field} is not a number"
end

Then(/^I stay on Request Form page$/) do
  expect(current_url).to eq("https://www.example.com/orders")
end

Then(/^I stay on Request Manager page$/) do
  expect(current_url).to eq("https://www.example.com/orders/manage")
end

Then(/^I stay on Admin Home page$/) do
  expect(current_url).to eq("https://www.example.com/admin/users/new")
end

Then(/^I stay on Place a Request page$/) do
  expect(current_url).to eq("https://www.example.com/orders")
end
#save_and_open_page
