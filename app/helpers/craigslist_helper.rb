require "watir-webdriver"
require "headless"
  module CraigslistHelper
   class Scraper < Watir::Browser
        
    def start(url) 
      Watir.default_timeout = 300 
      goto("#{url}")
      crawl
    end 

    def crawl
      if a(class: "button next").present?
        next_page
      else 
        get_first_page 
      end
    end   

    def get_first_page
      listings = []

      links(class: "hdrlnk").collect { 
        |link|
        listings << link.href 
      }
      listings.each do |listing|
        sleep(1.2)
        goto("#{listing}")
        check_for_elements
      end 
    end 


    def next_page
      while a(class: "button next").present? 
        listings = []
        sleep(1.7)
        links(class: "hdrlnk").each do |link|
          listings << link.href 
        end 
        sleep(2.2)
        a(class: "button next").when_present.click 
      end
        listings.each do |listing|
          goto("#{listing}")
          check_for_elements
        end 
    end 

    def check_for_elements 
      sleep(1.4)
      if section(id: "postingbody").present? && h2(class: "postingtitle").present? 
        sleep(1.3)
        scrape_url(url)
      else 
        puts "nothing to scrape here"
      end 
    end 

    def scrape_url(url) 
      if img.present?
        image = img.src
      else 
        image = "No image for this ad"
      end 
      if a(class: "showcontact").present?
        a(class: "showcontact").click
        number = section(id: "postingbody").text.tr("^[0-9]$", " ")
      else
        number = "No number button found. Check the body."
      end   
      title = h2(class: "postingtitle").text
      body = section(id: "postingbody").text
      number = section(id: "postingbody").text.tr("^[0-9]$", " ")
      Craigslist.create!(site: url, title: title, body: body, number: number, image: image)
    end 
  end            
end
