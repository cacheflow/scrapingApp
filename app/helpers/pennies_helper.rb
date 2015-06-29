module PenniesHelper
  class Scraper < Watir::Browser 
    def start(url)
      goto("#{url}")  
      sleep(2.3)
      crawl 
    end

    def crawl 
      Watir.default_timeout = 10000 
      ad_links = []
      next_page = true
      while next_page
          
          begin
            lis(class: "textvaluesContainer").collect {|link|
              ad_links << link.a.href}
          rescue 
            retry 
          end     
          
          begin 
            as(class: "next")[0].click
          rescue 
            retry 
          end    

          if url.include?("page-22")
            next_page = false 
          end  
          # lis(class: "textvaluesContainer").collect {|link|
          #     ad_links << link.a.href} 
      end 
        ad_links.each do |link_href| 
          begin 
            goto("#{link_href}")
          rescue 
            retry 
          else 
            check_for_elements
          end
        end 
    end 

    def check_for_elements
      if h1(class: "detailsTitle").present? && div(class: "mainInfoSection clearfix").present? && div(class: "js_expandable description").present?
        first_scrape 
      elsif  h1(class: "detailsTitle").present? && div(class: "description").present? && div(class: "contactSection clearfix").present?
        second_scrape
      elsif h1(class: "businessName").present? && div(class: "leftColumn").present?
        third_scrape
      elsif h1(class: "detailsTitle").present? && div(class: "mainInfoSection clearfix").present? && div(class: "description").present? && div(class: "cfSection urls").present?
        fourth_scrape
      elsif h1(class: "detailsTitle").present? && div(class: "mainInfoSection clearfix").present? && div(class: "cfSection description").present?
        fifth_scrape 
       elsif h1(class: "detailsTitle").present? && div(class: "mainInfoSection clearfix").present? && div(class: "description").present? 
        last_scrape 
      elsif ul(class: "location").present? && div(class: "mainInfoSection clearfix").present?
        simple_scrape 
      else 
        puts "nothing to scrape here"
      end 
    end 

    def first_scrape 
      title = h1(class: "detailsTitle").text 
      body = div(class: "js_expandable description").text
      contact =  div(class: "mainInfoSection clearfix").text 
      if a(id: "show_big_photo_layer").img.present? 
        image = browser.a(id: "show_big_photo_layer").img.src
      else 
        image = "No image for this ad"
      end 

      Penny.create!(
        site: url,
        title: title, 
        body: body, 
        contact: contact,
        image: image
      )
    end  

    def second_scrape 
      title = h1(class: "detailsTitle").text 
      body = div(class: "description").text
      contact =  div(class: "contactSection clearfix").text
      if a(id: "show_big_photo_layer").img.present? 
        image = browser.a(id: "show_big_photo_layer").img.src
      else 
        image = "No image for this ad" 
      end 

       Penny.create!(
        site: url,
        title: title, 
        body: body, 
        contact: contact,
        image: image
      )
    end

    def third_scrape 
      title = h1(class: "businessName").text
      body = div(class: "js_expandable").text 
      contact = div(class: "description").text

      if a(id: "show_big_photo_layer").img.present? 
        image = browser.a(id: "show_big_photo_layer").img.src
      else 
        image = "No image for this ad"
      end 
       Penny.create!(
        site: url,
        title: title, 
        body: body, 
        contact: contact,
        image: image
      )
    end 

    def fourth_scrape
      title = h1(class: "detailsTitle").text
      contact = div(class: "mainInfoSection clearfix").text
      site = div(class: "cfSection urls").text
      body = div(class: "description").text + "#{site}"

      if a(id: "show_big_photo_layer").img.present? 
        image = browser.a(id: "show_big_photo_layer").img.src
      else 
        image = "No image for this ad"
      end 

      Penny.create!(
      site: url,
      title: title, 
      body: body, 
      contact: contact,
      image: image
      ) 
    end

    def fifth_scrape
      title = h1(class: "detailsTitle").text
      contact = div(class: "mainInfoSection clearfix").text
      body = div(class: "cfSection description").text

      if a(id: "show_big_photo_layer").img.present? 
        image = browser.a(id: "show_big_photo_layer").img.src
      else 
        image = "No image for this ad"
      end 

      Penny.create!(
      site: url,
      title: title, 
      body: body, 
      contact: contact,
      image: image
      ) 
    end

    def last_scrape 
      title = h1(class: "detailsTitle").text
      contact = div(class: "mainInfoSection clearfix").text
      body = div(class: "description").text

      if a(id: "show_big_photo_layer").img.present? 
        image = browser.a(id: "show_big_photo_layer").img.src
      else 
        image = "No image for this ad"
      end 

      Penny.create!(
      site: url,
      title: title, 
      body: body, 
      contact: contact,
      image: image
      ) 
    end 

    def simple_scrape 
      title = h1(class: "detailsTitle").text
      body = "no description for this ad"
      contact = ul(class: "location").text
      image = "no image for this ad"
      Penny.create!(
        site: url, 
        title: title,
        body: body,
        contact: contact, 
        image: image
        )
    end 
  end  
end
