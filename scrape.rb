require "mechanize"
require "nokogiri"
require "open-uri"

class Scraper < Mechanize 

  def scrape(site)
    page = get("#{site}")
    find_elements(page) 
  end 

  def find_elements(page)
    puts page.at("div.ad-detail-header") 
  end 
  
end 

scraper = Scraper.new 

scraper.scrape("http://www.recycler.com/details/-44078580/yorkie-puppies")