require 'spec_helper'

describe Scraper do
  it 'provides a Scraper class to organize site-specific scrapers into classes' do
    Scraper.class.should be Module
  end
end
