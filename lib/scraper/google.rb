module Scraper
  class Google
    include Capybara::DSL
    Capybara.app_host = "http://www.google.com"
      
    def search(query="I love Ruby!")
      visit('/')

      wait = 0 unless wait
      sleep(wait)
      wait += 5

      fill_in("q", :with => query)
      click_button "Google Search"
      result = []
      all("li.g h3").each do |h3| 
        a = h3.find("a")
        result <<  "#{h3.text}  =>  #{a[:href]}"
      end
      result
      
    rescue Capybara::ElementNotFound
      retry unless wait > 15
    end
  end
end