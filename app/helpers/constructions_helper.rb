require "watir-webdriver"
module ConstructionsHelper
  class Scraper < Watir::Browser 
    
    def start(url)
      Watir.default_timeout = 2020
      goto("#{url}") 
      crawl 
    end 

    def crawl 
      ads = []
      h3s(class: "result-title").collect {|h3| ads << h3.a.href} 
      ads.each do |ad|
        goto("#{ad}")
        check_if_page_is_english_or_spanish  
      end      
    end 

    def check_if_page_is_english_or_spanish
      if h2(id: "site-description").text.include?("USA")
        check_for_elements_on_english_page
      else 
        check_for_elements_on_spanish_page 
      end 
    end 


    def check_for_elements_on_spanish_page 
      if h1(class: "block-title").present? && span(class: "hidden-number").present? && img.present? && div(class: "block-content").present? && div(class: "block-content").text.include?("Más")
        scrape_spanish_page
      end
    end 

      def check_for_elements_on_english_page
      if h1(class: "block-title").present? && span(class: "hidden-number").present? & table.text.include?("Additional") 
        scrape_english_page
      end
    end 

    def scrape_english_page 
      Construction.create!(
        site: url,
        brand: h1(class: "block-title").text,
        description: table.text.gsub!(/.*(?=additional)/im, ""),
        number: span(class: "hidden-number").text, 
        image: img.src
        ) 
    end 

    def scrape_spanish_page 
      image = ""
      if img(class: "image_main").present? 
        image = img(class: "image_main").src 
      elsif img.src.present? 
        image = img.src
      else 
        image = "No image for this ad"
      end 
      brand = []
      trs(class: "gray").map {
        |tr| next if tr.text.include?("Seleccione una moneda")
        brand << tr.text }
      joined_string = brand.join 
      span(class: "hidden-number").click
      
      Construction.create!(
        site: url,
        brand: h1(class: "block-title").text,
        description: joined_string.encode("UTF-8"),
        number: span(class: "hidden-number").text, 
        image: image
        ) 
    end 
  end
end