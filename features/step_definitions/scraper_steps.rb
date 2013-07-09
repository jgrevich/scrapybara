Given(/^a scraper$/) do
  @scraper = Scraper::Edgar.new # express the regexp above with the code you wish you had
end

When(/^I ask it to download the index$/) do
  @content = @scraper.download_index# express the regexp above with the code you wish you had
end

Then(/^I should see "(.*?)"$/) do |arg1|
  @content.should /.*txt/ # express the regexp above with the code you wish you had
end
