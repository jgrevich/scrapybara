require 'spec_helper'

describe Scraper::Google do
  
  it 'provides a class object to organize scraping methods' do
    Scraper::Google.class.should be Class
  end
  
end