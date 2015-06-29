require "mechanize"
module BackpagesHelper
  class Scraper < Mechanize
    
    def start(site)
      get("#{site}")
      next_button = current_page.link_with(class: "pagination next")
      
      if !next_button
        scrape_first_page  
      else 
        scrape_every_page
      end 
    end 

    def scrape_first_page
      first_page_links = []
      current_page.search("div.cat > a").each do |div|
        first_page_links << div.attribute("href").to_s 
      end
      first_page_links.each do |link|  
        agent.get("#{link}") 
        check_for_elements
      end   
    end  

    def scrape_every_page 
      links = []
      next_page = true 
      while next_page 
        if current_page.link_with(class: "pagination next")
          current_page.search("div.cat > a").each do |div|
            links << div.attribute("href").to_s
            puts div.attribute("href").to_s 
          end 
          sleep(2.1)
          current_page.link_with(class: "pagination next").click
        else   
          next_page = false
        end 
      end

      links.each do |link|
        sleep(2.3)
        get("#{link}")
        check_for_elements
      end 
    end 

    def check_for_elements 
      if current_page.at("div#postingTitle") && current_page.at("div.postingBody")
        scrape
      end 
    end 

    def scrape 
      if current_page.at("ul#viewAdPhotoLayout > li > a > img")
        image = current_page.at("ul#viewAdPhotoLayout > li > a > img").attribute("src").text
      else 
        image = "No image for this ad"
      end 
      Backpage.create!(
        site: current_page.uri,
        title: current_page.at("div#postingTitle").text, 
        body: current_page.at("div.postingBody").text, 
        image: image
        )
    end 
  end
end