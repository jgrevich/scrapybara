require 'spec_helper'

describe Scraper::Edgar do
  
  it 'provides a class object to organize scraping methods' do
    Scraper::Edgar.class.should be Class
  end
  
  describe Scraper::Edgar.recent_date do

    it "returns the last friday when it's sunday" do
      Scraper::Edgar.recent_date(Date.new(2013,4,7)).wday.should eq(5)
    end

    it "returns the last friday when it's saturday" do
      Scraper::Edgar.recent_date(Date.new(2013,4,6)).wday.should eq(5)      
    end

    it "returns the most recent date given a weekday" do
      Scraper::Edgar.recent_date(Date.new(2013,4,5)).wday.should eq(5)      
    end

  end
  
  describe '.app_host' do
    
    before { @scraper = Scraper::Edgar.new }
    
    it 'sets the Capybara.app_host to "http://www.sec.gov" by default' do
      Capybara.app_host.should eq("http://www.sec.gov")
    end
  
    it 'responds with the current app_host value' do
      new_host = "https://grevi.ch"
      @scraper.stubs(:app_host).returns(new_host)

      @scraper.app_host.should eq(new_host)      
    end

    it 'sets the current app_host value' do
      @scraper.app_host = new_host = "https://grevi.ch"

      @scraper.app_host.should eq(new_host)      
      Capybara.app_host.should eq(new_host)
    end

    it 'validates the hostname' do
      lambda { @scraper.app_host = new_host = "grevi .ch"}.should raise_error      
    end

    it 'validates the inclusion of a hostname in the app_host' do
      lambda { @scraper.app_host = new_host = "ftp://google.com"}.should raise_error, "must be a valid hostname"
    end 
       

  end
  
  describe '.daily_index_url' do
    
    before do
      @scraper = Scraper::Edgar.new
      @date = Scraper::Edgar.recent_date
      @given_date = Date.new(2012,12,21)
    end    
    
    it 'returns the url for the most recent daily index' do
      @scraper.daily_index_url.should eq("/Archives/edgar/daily-index/master.#{@date.strftime("%Y%m%d")}.idx")
    end

    it 'returns the url for the given date' do
      @scraper.daily_index_url(@given_date).should eq("/Archives/edgar/daily-index/master.#{@given_date.strftime("%Y%m%d")}.idx")
    end
    
  end
  
  describe '.import_filings' do
    
    before do
      @scraper = Scraper::Edgar.new
    end
    
    it 'raises an error if the date is a US Federal Holiday' do
      lambda { @scraper.import_filings(Date.new(2012,12,25)) }.should raise_error RuntimeError
    end

    it 'raises an error if the date is not a weekday' do
      sunday = Date.new(2012,12,16)
      lambda { @scraper.import_filings(sunday) }.should raise_error RuntimeError
    end    

  end
  
  describe '.holiday?(date)' do
    
    it 'returns true if the specified date is a US holiday' do
      Scraper::Edgar.holiday?(Date.new(2012,12,25))
    end
  
  end
  
end