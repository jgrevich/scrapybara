require 'spec_helper'

describe Scraper::Edgar::Filing do
  before { @filing = FactoryGirl.create(:filing) }
  
  it 'provides a class object to organize scraping methods' do
    Scraper::Edgar::Filing.class.should be Class
  end
  
  it 'validate_uniqueness_of(:cik)' do
    expect { Scraper::Edgar::Filing.create!(cik => @filing.cik) }.to raise_error
  end

  it 'provides a symbol for all known FORM_TYPES' do
    Scraper::Edgar::Filing::FORM_TYPES.include?('10-K').should be true 
  end
  
  describe '.cached_filing?(date=Scraper::Edgar.recent_date)' do
    pending
    Scraper::Edgar::Filing.cached_index?(Time.now + 30.days)
  end
  
  describe '.import_documents' do
    before(:all) do
      @filing = FactoryGirl.create(:filing)
      @html = File.open(File.join(SCRAPER_ROOT, 'spec', 'fixtures', 'filing_detail.html'), 'r').read
      @nokod = Nokogiri::HTML(@html)
      @tables = @nokod.xpath('//table[@summary]')
      @non_header_rows = @tables.first.css('tr:nth-child(n+1)')
    end
      
    it 'visits the detail page of the filing object' do
      @filing.detail_url.should eq("/Archives/edgar/data/#{@filing.cik}/#{@filing.accession_number.gsub('-','')}/#{@filing.accession_number}-index.htm")
    end
    
    it 'parses the html through nokogiri and grabs tables' do  
      @nokod.should be_kind_of Nokogiri::HTML::Document
      @tables.first.name.should eq('table')
    end
    
    it 'verifies the inclusion of headers specific to tables with filing documents' do
      headers = @tables.first.css('tr:nth-child(1)').children.text.scan(/(\w+)\n/).flatten
      headers.should eq(["Seq", "Description", "Document", "Type", "Size"])
    end

    it 'parses each non-header table row for document details' do
      pending      
      @non_header_rows.each do |row|
        seq = row.css('td')[0].text
        description = row.css('td')[1].text
        document_name = row.css('td')[2].text
        document_type = row.css('td')[3].text
        
        document_url = row.css('td a').attribute('href')

        visit document_url
      end
      
    end
    
    it 'downloads the document' do
      pending
      document_url =  @non_header_rows.first.css('td a').attribute('href')
      
      @filing.download document_url
      
      stub(:visit)
      page.stub(:html)
    end

    it 'attaches the document to a new document object' do
      
      pending
    end
  
    it 'prints out a list of imported_documents when finished' do
      
    end
  end
  
end