module Scraper
  class Edgar
    class Filing
      include Scraper
      include Capybara::DSL
      Capybara.run_server = false
      Capybara.current_driver = :webkit
      ### mongoid config
       include Mongoid::Document
       include Mongoid::Timestamps
       
       field :cik, type: Integer
       field :accession_number, type: String
       field :company_name, type: String
       field :form_type, type: String
       field :filed_on, type: Date
       field :file_name, type: String
       field :accepted_at, type: DateTime
       field :irs_number, type: Integer
       field :state_of_incorporation, type: String
       field :fiscal_year_end, type: Integer
       field :act, type: Integer
       field :file_number, type: String
       field :film_number, type: Integer
       field :sic, type: Integer
       field :business_address, type: String
       field :mailing_address, type: String

      attr_accessor :attachments_attributes, :attachment_attributes, :attachment
      
      FORM_TYPES = [ "1-A/A", "10-12G/A", "10-D", "10-K", "10-K/A", "10-Q", "10-Q/A", "13F-HR", "13F-NT", "144", "15-12B", "15-12G", "15-15D", "20-F", "20-F/A", "24F-2NT", "25", "25-NSE", "3", "3/A", "305B2", "4", "4/A", "40-17F2", "40-17G", "40-17G/A", "40-24B2", "40-APP/A", "424B2", "424B3", "424B4", "424B5", "425", "485APOS", "485BPOS", "485BXT", "487", "497", "497AD", "497J", "497K", "5", "6-K", "8-A12B", "8-K", "8-K/A", "ARS", "AW", "CB/A", "CERTNAS", "CERTNYS", "CORRESP", "CT ORDER", "D", "D/A", "DEF 14A", "DEF 14C", "DEFA14A", "DEFA14C", "DEFC14A", "DEFM14A", "DEFR14A", "DFAN14A", "DRS", "DRS/A", "EFFECT", "F-1", "F-1/A", "F-3", "F-3/A", "F-6 POS", "F-6/A", "F-6EF", "F-X", "FOCUSN", "FWP", "IRANNOTICE", "N-2", "N-2/A", "N-8F/A", "N-CSR", "N-CSR/A", "N-CSRS", "N-Q", "NT 10-Q", "NT-NCSR", "POS AM", "POS AMI", "POS EX", "POSASR", "PRE 14A", "PRE 14C", "PREC14A", "PRER14A", "PX14A6G", "RW", "S-1", "S-1/A", "S-11/A", "S-1MEF", "S-3", "S-3/A", "S-4", "S-4/A", "S-6/A", "S-8", "S-8 POS", "SC 13D", "SC 13D/A", "SC 13E3", "SC 13E3/A", "SC 13G", "SC 13G/A", "SC 14D9/A", "SC TO-C", "SC TO-I", "SC TO-I/A", "SC TO-T/A", "TA-2", "UPLOAD", "X-17A-5"]
       
      embeds_many :attachments, :cascade_callbacks => true, :class_name => "Scraper::Edgar::Attachment", validate: true
      accepts_nested_attributes_for :attachments
      
      validates_uniqueness_of :accession_number
      
      scope :form_10k, where(form_type: '10-K')
      scope :form_10q, where(form_type: '10-Q')
      
      class << self
                
        # parse EDGAR daily index entries and create Filing objects. NOTE: this probably belongs in Scraper::Edgar::Filing
        def import_from_index_text(filing_text)
         filing_text_array = filing_text.split(/-{80}\n? ?/).last.split('.txt ')

          @filings = []
          filing_text_array.each do |entry|
            filing_values = entry.split('|')
           @filings << Scraper::Edgar::Filing.create(cik: filing_values[0], accession_number: filing_values[4].scan(/.*\/(\d+-\d+-\d+).*/).flatten.first, company_name: filing_values[1], form_type: filing_values[2], filed_on: Date.parse(filing_values[3]), file_name: filing_values[4] )
          end
 
          @filings
        end
                
        # returns the cached filing for the given date if it exists or false if not
        def cached_index?(date=Scraper::Edgar.recent_date)
          File.exists? File.join(SCRAPER_ROOT,'data', 'html', 'edgar_indexes', Scraper::Edgar.date_format(date) + '.html')
        end
      end # end class self

      # return url for detailed filing information
      def detail_url
        "/Archives/edgar/data/#{cik}/#{accession_number.gsub('-','')}/#{accession_number}-index.htm"
      end
      
      # by default we only import the filing index, documents must be loaded 
      # manually to improve responsiveness on large imports
      def import_filling_details
        # it 'visits the detail page of the filing object'
        Capybara.app_host = "http://www.sec.gov"
        visit detail_url
        
        raise "404 The requested URL was not found on the server." if page.has_content?("404. That's an error. The requested URL")
        raise "EDGAR is Down for Maintenance, BOOHOO sec.gov" if page.has_content?("Down for Maintenance")
      
        # it 'parses the html through nokogiri and grabs tables'
        nokod = Nokogiri::HTML(page.html)      
        # we may want to be more specific with the @summary attribute (e.g. [@summary="match this text"])
        tables = nokod.xpath('//table[@summary]')
        
        tables.each do |table|
          rows = table.css('tr')
          headers = table.css('tr:nth-child(1)').children.text.scan(/(\w+)\n/).flatten
          
        end
        
        filed_on                    = Date.parse(page.text.scan(/Filing Date (\d{4}-\d{2}-\d{2})/).flatten.first) if page.text.scan(/Filing Date (\d{4}-\d{2}-\d{2})/)
        accepted_at                 = DateTime.parse(page.text.scan(/Accepted (\d{4}-\d{2}-\d{2})/).flatten.first) if page.text.scan(/Accepted (\d{4}-\d{2}-\d{2})/)
        irs_number                  = page.text.scan(/IRS No\.\: (\d+)/).flatten.first
        state_of_incorporation      = page.text.scan(/State of Incorp\.\: (\w{2})/).flatten.first
        fiscal_year_end             = page.text.scan(/Fiscal Year End\: (\d{4})/).flatten.first
        act                         = page.text.scan(/Act\: (\d+)/).flatten.first
        file_number                 = page.text.scan(/File No\.\: (\d+)/).flatten.first
        film_number                 = page.text.scan(/Film No\.\: (\d+)/).flatten.first
        sic                         = page.text.scan(/SIC\: (\d+)/).flatten.first
        
        self.update_attributes( filed_on: filed_on,
          accepted_at: accepted_at,
          irs_number: irs_number,
          state_of_incorporation: state_of_incorporation,
          fiscal_year_end: fiscal_year_end,
          act: act,     
          file_number: file_number,            
          film_number: film_number,
          sic: sic )
          
          puts 'updated ' + self.inspect + "\n\n"
          
      end

      # find and download filing document attachments
      def import_documents

        Capybara.app_host = "http://www.sec.gov"
        visit detail_url
        
        # it 'parses the html through nokogiri and grabs tables
        nokod = Nokogiri::HTML(page.html)
        tables = nokod.xpath('//table[@summary]')
        
        tables.each do |table|
          # it 'verifies the inclusion of headers specific to tables with filing documents
          headers = table.css('th').text
            next unless headers == "SeqDescriptionDocumentTypeSize"
        
          # parses each non-header table row for document details
          non_header_rows = table.css('tr:nth-child(n+2)')
          non_header_rows.each do |row|
            seq = row.css('td')[0].text
            description = row.css('td')[1].text
            document_name = row.css('td')[2].text
            document_type = row.css('td')[3].text
          
            # it creates the save location
            document_url = row.css('td a').attribute('href').value
            save_location = File.join(SCRAPER_ROOT, 'data', 'edgar', document_url)
            
            #debugger
            
            # it creates the directory structure if needed.
            FileUtils.mkpath save_location.split('/')[0..-2].join('/')
            
            # it download document
            
            system "wget -O #{save_location} #{Capybara.app_host}#{document_url}"

            # it 'attaches the document to a new document object
            document = File.open(save_location, 'r')
            attachment = self.attachments.create(sequencnce: seq.to_i, description: description, document_name: document_name, document_type: document_type, document_data: document.read, filing_id: self.id)
            if attachment.save
              puts "yay, saved attach"
            else
              puts attachment.errors.messages
            end
          end
        end
      end
      
    end
    
    # formats the date to edgar style (20121221)
    def self.date_format(date=RECENT_DATE)
      date.strftime("%Y%m%d")
    end
      
  end
end
