require 'spec_helper'

describe Scraper::Edgar do

  describe '.index_html' do
    before(:each) do
      @scraper = Scraper::Edgar.new
    end

    it 'returns the html of the recent daily index' do
      @scraper.visit @scraper.daily_index_url(Scraper::Edgar.recent_date)
      #debugger unless @scraper.index_html.include?('EDGAR Dissemination Feed')
      
      @scraper.index_html.include?('EDGAR Dissemination Feed').should eq(true)
    end
  end

  describe '.import_filings' do
    before(:all) do
      @scraper = Scraper::Edgar.new
      @scraper.visit @scraper.daily_index_url(Scraper::Edgar.recent_date)
    end
    
    it 'returns filings for the most recent filing date' do
      @scraper.import_filings.first.class.should eq(Scraper::Edgar::Filing)
    end
    
    it 'visits the Edgar filing index for the given day using a simulated webkit browser' do
      @scraper.page.should have_content("10-K")
    end
    
    it 'saves the filing index to html in the data dir' do
      path = File.join(SCRAPER_ROOT, 'tmp', 'data', 'edgar', 'html', 'daily_index', Scraper::Edgar.date_format+'.html')
      @scraper.page.save_page path
      File.exists?(path).should be true
    end
    
    
    context 'with filing objects' do
      before { @filings = Scraper::Edgar::Filing.import_from_index_text @scraper.page.find('pre').text }

      it 'parses the html for Scraper::Edgar::Filing.objects' do
        @filings.first.class.should be Scraper::Edgar::Filing
      end
    
      it "stores filing objects to mongodb" do
        Scraper::Edgar::Filing.create(cik: 1234)
        Scraper::Edgar::Filing.last.cik.should eq(1234)
      end
    end
  end # end describe '.import_filings'
    
end