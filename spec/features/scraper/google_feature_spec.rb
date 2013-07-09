require 'spec_helper'

describe Scraper::Google do
  
  describe '.search(query)' do
    before { @scraper = Scraper::Google.new }
    
    it 'returns search results for "I love Ruby!" without a query' do
      pending "occassionaly yields QFont::setPixelSize: Pixel size <= 0 (0); Unable to find field 'q'"
      result = @scraper.search
      result.first.should match(/([rR]uby)/)
    end
  end
  
end