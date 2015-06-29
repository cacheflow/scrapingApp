module CraigslistsHelper
  def get(site)
    @agent = Mechanize.new 
    @agent.user_agent = ["Chrome", "Linux Firefox", "Windows Mozilla", "iPhone", "iPad", "Android", "Mac FireFox", "Mac Safari"].sample
    @page = @agent.get("#{site}")
    @ads = @page.links_with(:class => "hdrlnk")
    @links = []
    # @ads.each do |url|
    #   @links << url.href 
    # end 
    # @city = site.match("^([^.]*).*")[1]
     # @nokogiri_parse.css(".postingtitle").each do |title| 
      #     puts title.text 
      #   @nokogiri_parse.css("#postingbody").each do |body| 
      #     puts body.text
      #   end 
  end   

end
