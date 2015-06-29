require "open-uri"
require "csv"
class Craigslist < ActiveRecord::Base 
  searchkick word_start: [:body]
  before_save :sanitize_site 


  def sanitize_site 
   if !self.site.include?("craigslist.org") || !self.site.include?("craigslist.org")
    self.site = "mascus.com"
   else 
    ActionController::Base.helpers.sanitize(self.site)
   end 
  end 

  def self.filtered_csv(craigslist)
    CSV.generate do |csv| 
      csv << ["Title", "Body", "Number", "Image"]
      craigslist.each do |craigs| 
        csv << [craigs.title, craigs.body, craigs.number, craigs.image]
      end
    end 
  end 

  def self.to_csv
    CSV.generate do |csv| 
      csv << ["Title", "Body", "Number", "Image"]
      Craigslist.all.each do |craigs| 
        csv << [craigs.title, craigs.body, craigs.number, craigs.image]
      end
    end 
  end 
end 

