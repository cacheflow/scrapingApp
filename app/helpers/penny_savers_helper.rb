module PennySaversHelper

  class Scraper < Watir::Browser 

    def start(url)
      Watir.default_timeout = 300 
      goto("#{url}")  
      crawl 
    end

    def crawl 
      @links = []
      while a(class: "next").present? 
        sleep(1.7)
        as(class: "advertTitle ng-isolate-scope").each do |link|
          @links << link.href 
        end 
      end
      links.each do |link| 
        goto("#{link}")
        check_for_elements
      end  
    end 

    def check_for_elements
      sleep(1.7)
      if h1(class: "detailsTitle").present? && div(class: "mainInfoSection clearfix").present && div(class: "js_expandable description")
        scrape_this 
      sleep(1.7)
      elsif  h1(class: "detailsTitle").present? && div(class: "description").present? && div(class: "contactSection clearfix").present?
        scrape_that
      else 
        puts "nothing to scrape here"
      end 
    end 

    def scrape_this 
      title = h1(class: "detailsTitle").text 
      body = div(class: "js_expandable description").text
      contact =  div(class: "mainInfoSection clearfix").text 

      Penny.create!(
        title: title, 
        body: body, 
        contact: contact
      )
    end  

    def scrape_that 
      title = h1(class: "detailsTitle").text 
      body = div(class: "description").body
      contact =  div(class: "contactSection clearfix").text

       Penny.create!(
        site: current_page.uri,
        title: title, 
        body: body, 
        contact: contact
      )
    end
  end  
end 