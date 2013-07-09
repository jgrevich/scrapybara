require 'bundler'
Bundler.require(:default, :development)

# require "addressable/template"

SCRAPER_ROOT = File.expand_path('.') 

Dir[File.join(SCRAPER_ROOT,"lib/scraper/*.rb")].each {|file| require file }

ENV["MONGOID_ENV"] = 'development'
Mongoid.load!(File.join(SCRAPER_ROOT, "config/mongoid.yml"), :development)

module Scraper
  include Capybara::DSL
  Capybara.run_server = false
  Capybara.current_driver = :webkit
  
  attr_reader :app_host
  attr_accessor :last_visited_path
  
  @app_host = 'http://www.sec.gov'
  
  def initialize(*args)
    app_host = args[0] || @app_host || 'http://www.sec.gov'
    
    Capybara.app_host=@app_host=app_host 
    super
  end
  
  def app_host=(host)
    case
    when Addressable::URI.parse(host).host == nil
      raise "must be a valid hostname"
    when Addressable::URI.parse(host).scheme != 'http' && Addressable::URI.parse(host).scheme != 'https'
      raise "host must contain http:// or https://"
    else
      Capybara.app_host = @app_host = host
    end
  end
  
  # downloads url to /data dir and recreates dir structure
  def download(url)
    # parse the url to guarentee path only for capybara
    path = Addressable::URI.parse(url).path
    Capybara.app_host = 'http://www.sec.gov'
    
    puts 'using cached page variable' if @last_visited_path == path
  
    # set last visited variable on successful page visit
    @last_visited_path = path if visit(path) && @last_visited_path != path
      
    raise "404 The requested URL was not found on the server." if page.has_content?("404. That's an error. The requested URL")
    raise "Down for Maintenance." if page.has_content?("Down for Maintenance")
    
    # mimic path in url on disk (should we use wget since it handle's all sorts of file types?)
    save_location = File.join(SCRAPER_ROOT, '/data/edgar/', path.split('/')[1..-1].flatten)
  
    # save html of filing index
    page.save_page save_location
  end

end