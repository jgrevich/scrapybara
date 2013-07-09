require 'simplecov'
SimpleCov.start

require 'rspec/autorun'
require "shoulda/matchers"
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/webkit'
require File.expand_path("lib/scraper")
require File.expand_path("spec/factories/filings")

#Capybara.javascript_driver = :poltergeist
Capybara.javascript_driver = :webkit
ENV["MONGOID_ENV"] = 'test'
Mongoid.load!(File.join(SCRAPER_ROOT, "config/mongoid.yml"), :test)

FactoryGirl.definition_file_paths = [File.expand_path("spec/factories")]


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :mocha
  config.order = "random"
  config.fail_fast = true
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
