require "mechanize"
require "nokogiri"
require "open-uri"
module RecyclersHelper
  class Scraper < Mechanize

    def self.initialize
      aliases = ["Linux Konqueror", "Mozilla/5.0 (compatible; Konqueror/3; Linux)", "Linux Mozilla", "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624", "Mac Firefox", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6", "Mac Mozilla", "Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.4a) Gecko/20030401", "Mac Safari 4", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_2; de-at) AppleWebKit/531.21.8 (KHTML, like Gecko) Version/4.0.4 Safari/531.21.10", "Mac Safari", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/534.51.22 (KHTML, like Gecko) Version/5.1.1 Safari/534.51.22", "Windows Chrome", "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.32 Safari/537.36", "Windows IE 6", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)", "Windows IE 7", "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)", "Windows IE 8", "Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322; .NET CLR 2.0.50727)", "Windows IE 9", "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)", "Windows Mozilla", "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.4b) Gecko/20030516 Mozilla Firebird/0.6", "iPhone", "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3", "iPad", "Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.10", "Android", "Mozilla/5.0 (Linux; U; Android 3.0; en-us; Xoom Build/HRI39) AppleWebKit/534.13 (KHTML, like Gecko) Version/4.0 Safari/534.13", "Mac FireFox", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6", "Linux FireFox", "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.1) Gecko/20100122 firefox/3.6.1"]
      user_agent_alias = "#{aliases.sample}"
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
      get("#{url}")
      if current_page.link_with(class: "next")
        puts "calling the get_links_from_every_page method"
        get_links_from_every_page(url, pages)
      else
        puts "calling the get_links_from_first_page method"
        get_links_from_first_page
      end
    end


    def get_links_from_first_page
      puts "Crawling first page"
      listings = []
      current_page.search("div.ad-summary-text > h3 > a").each do |div|
        if !div.attribute("href").include?("recycler.com")
          listings << "http://recycler.com#{div.attribute("href")}"
        else
          listings << div.attribute("href")
        end
      end
      listings.each do |link|
        begin
          sleep(2.1)
          get("#{link}")
        rescue Exception => e
          puts "Error is #{e}"
          if retries <= 3
            puts "Trying to scrape the site again. If this fails, then I'll try with Nokogiri"
            retries += 1
            retry
          else
            nokogiri = Nokogiri.new
            puts "I'll try scraping with nokogiri now"
            nokogiri.open_url("#{current_page.uri}")
          end
        else
          check_for_elements
        end
      end
    end





    def get_links_from_every_page(url, pages)
      puts "Crawling every page..."
      listings = []
      next_page = true
      clicked_next_number_of_times = 0
      pages.to_i
      while next_page
        if  clicked_next_number_of_times == pages || (current_page.link_with(class: "next").nil?)
          next_page = false
        else
          current_page.search("div.ad-summary-text > h3 > a").each do |div|
            if !div.attribute("href").include?("recycler.com")
              listings << "http://recycler.com#{div.attribute("href")}"
            else
              listings << div.attribute("href")
            end
          end
          clicked_next_number_of_times += 1
          puts clicked_next_number_of_times
          puts "WE GOING THROUGH ALL THE PAGES #{current_page.uri}"
          sleep(2.7)
          current_page.link_with(class: "next").click
        end
      end
      listings.each do |link|
        begin
         sleep(2.1)
         get("#{link}")
        rescue Exception => e
          puts "Error is #{e}"
          if retries <= 3
            puts "Trying to scrape the site again. If this fails, then I'll try with Nokogiri"
            retries += 1
            retry
          else
            nokogiri = Nokogiri.new
            puts "I'll try scraping with nokogiri now"
            nokogiri.open_url("#{current_page.uri}")
          end
        else
          check_for_elements
        end
      end
    end





    def scrape_first_page
      current_page.search("div.ad-summary-text > h3 > a").each do |div|
        if !div.h3.a.href.include?("recycler.com")
          listings << "http://recycler.com#{div.attribute("href")}"
        else
          listings << div.attribute("href")
        end
      end
      listings.each do |listing|
        begin
          sleep(2.1)
          get("#{listing}")
        rescue
          retry
        else
          check_for_elements
        end
      end
    end


    def check_for_elements
      begin
        if current_page.at("div.ad-detail-header") && current_page.at("div.ad-profile-address") && current_page.at(class: "ad-profile-phones") && current_page.at("div#ad-desc")
        end
      rescue
        retry
      else
        scrape
      end
    end

    def scrape
      if current_page.at("li > img") && !current_page.at("li > img").attribute("src").value.include?("recycler.com")
        image = "http://recycler.com/#{current_page.at("li > img").attribute("src").value}"
      elsif current_page.at("li > img")
        image = current_page.at("li > img").attribute("src").value
      else
        image = "no image for this ad"
      end
      if current_page.at("div.ad-detail-header") && current_page.at("div#ad-desc") && current_page.at("div.ad-profile-address > p")
        title = current_page.at("div.ad-detail-header").text
        body = current_page.at("div#ad-desc").text
        advertiser = current_page.at("div.ad-profile-address > p").text
      end

        Recycler.create!(
        site: current_page.uri,
        title: title,
        body: body,
        advertiser: advertiser,
        image: image
        )

    end
  end
end
