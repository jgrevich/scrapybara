module Scraper
  class Edgar
    require 'scraper/edgar/attachment'
    require 'scraper/edgar/filing'
    include Scraper
    include Capybara::DSL
    Capybara.run_server = false
    Capybara.current_driver = :webkit
      
    def self.recent_date(date=Time.now)
      # since the report is not released at midnight, buffer at least
      # 24 hours if date is within 24 hours of Time.now.
      date = (date - 1.day) if (Time.now - date.to_datetime) < 24.hours
      case 
      when date.wday == 0
        recent_date = date-2.days
      when date.wday == 6  
        recent_date = date-1.day
      else
        recent_date = date
      end
    end
    
    def self.holiday?(date=Date)
     !::Holidays.on(date, :us).blank?
    end
    
    # formats the date to edgar style (20121221)
    def self.date_format(date=RECENT_DATE)
      date.strftime("%Y%m%d")
    end
      
    RECENT_DATE = Scraper::Edgar.recent_date
      
    # download filing index to html and import filing entries into Filing objects and serialize data to yaml. NOTE: split this guy up, it sounds like 3 methods
    def import_filings(date=RECENT_DATE)
      raise "Cannot import on a holiday since no data exists." if Scraper::Edgar.holiday?(date)
      raise "Cannot import on a weekend since no data exists." if date.saturday? || date.sunday?
      
      # visit daily index url
      visit daily_index_url(date)
      
      # save html of filing index
      page.save_page File.join(SCRAPER_ROOT, 'data', 'edgar', 'html', 'daily_index', Scraper::Edgar.date_format(date)+'.html')
      
      # parse html file for Filing data
      filings = Scraper::Edgar::Filing.import_from_index_text page.find('pre').text
    end
    
    
    # return the html for the edgar index of the given date (or the most recent index)
    def index_html(date=RECENT_DATE)
      visit daily_index_url(date)

      page.html
    end  
   
    # returns formated path for edgar index of the given date (or today)
    def daily_index_url(date=RECENT_DATE)
      "/Archives/edgar/daily-index/master.#{Scraper::Edgar.date_format(date)}.idx"
    end

  end
end
