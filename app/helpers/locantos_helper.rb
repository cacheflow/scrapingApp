require "headless"
require "watir-webdriver"
require "mechanize"

module LocantosHelper
  class Scraper < Mechanize 
   
    def self.initialize 
      aliases = ["Linux Konqueror", "Mozilla/5.0 (compatible; Konqueror/3; Linux)", "Linux Mozilla", "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624", "Mac Firefox", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6", "Mac Mozilla", "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.4a) Gecko/20030401", "Mac Safari 4", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-at) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10", "Mac Safari", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/534.51.22 (KHTML, like Gecko) Version/5.1.1 Safari/534.51.22", "Windows Chrome", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.32 Safari/537.36", "Windows IE 6", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)", "Windows IE 7", "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)", "Windows IE 8", "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)", "Windows IE 9", "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)", "Windows Mozilla", "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6", "iPhone", "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3", "iPad", "Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10", "Android", "Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13", "Mac FireFox", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6", "Linux FireFox", "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.1) Gecko/20100122 firefox/3.6.1"]
      self.user_agent = "Mac Safari"
      follow_meta_refresh = false
      history.max_size = 10
      max_history = 1
      read_timeout = 10
      open_time = 10
      read_time = 10
      keep_alive = false
    end 

    def start(url, pages)
      puts user_agent
      listings = []
      next_page = true 
      clicked_next_number_of_times = 0 
      get("#{url}")
      if !current_page.search("strong:contains('Next')").empty? 
        puts "calling the get_links_from_every_page method"
        get_links_from_every_page(url, pages)
      else 
        puts "calling the get_links_from_first_page method"
        get_links_from_first_page(url, pages)
      end 
    end 

    def get_links_from_first_page(url, pages)
      listings = []
      current_page.search("div.resultMain > span > a").each do |link| 
        listings << link.attribute("href").value
      end 
      listings.each do |link|
        sleep(2.3)
        get("#{link}")
        check_for_elements
      end 
    end 
  
    def get_links_from_every_page(url, pages)
      puts "Crawling every page..."
      listings = []
      next_page = true 
      clicked_next_number_of_times = 0
      pages = pages.to_i - 1 
      while next_page 
        if  clicked_next_number_of_times == pages || current_page.search("strong:contains('Next')").empty?
          next_page = false 
        else
          sleep(2.3)
          get("#{page.search('div.paging > a').last.attribute('href').value}")
          current_page.search("div.resultMain > span > a").each do |link| 
            listings << link.attribute("href").value
          end 
          clicked_next_number_of_times += 1  
          puts clicked_next_number_of_times
          puts "WE GOING THROUGH ALL THE PAGES #{current_page.uri}" 
        end
      end 
      listings.each do |link|
        sleep(2.3)
        get("#{link}") 
        check_for_elements
      end 
    end  

    def check_for_elements
      image = nil
      if current_page.at("img#big_img").attribute("src").value.start_with?("http://images.locanto.com")
        image = current_page.at("img#big_img").attribute("src").value
      else 
        image = "no image for this ad"
      end  
      if content_with_no_number?
        Locanto.create!(
          site: current_page.uri,
          title: current_page.at("span.h2").text,
          body: current_page.at("div#js-user_content").text, 
          image: image,  
          number: "No number field for this ad. Check the body"  
        )
      elsif content_with_number? 
        browser = Browser.new 
        browser.launch_watir_browser(current_page.uri) 
      end 
    end 

    def content_with_no_number? 
      current_page.search("span.h2") && current_page.search("div#js-user_content") && !current_page.link_with(class: "js-obf")
    end  

    def content_with_number?
      current_page.search("span.h2") && current_page.search("div#js-user_content") && current_page.link_with(class: "js-obf")
    end 
  end

  class Browser < Watir::Browser
    # attr_accessor :headless
    def launch_watir_browser(site)
      # headless = Headless.new 
      # headless.start 
      goto("#{site}")
      scrape_content
    end 

    def scrape_content
      browser.a(class: "js-obf").click
      if browser.img.(id: "big_img").src.start_with?("http://images.locanto.com") 
        image = browser.img.src 
      else 
        image = "no image for this ad"
      end 
      Locanto.create!(
        site: url, 
        title: span(class: "h2").text,
        body: div(id: "js-user_content").text, 
        image: image, 
        number: browser.divs(class: "mybox small")[1].text
        )
        close
        # headless.destroy
    end 
  end 
end 





