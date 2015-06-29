require "csv"
class Backpage < ActiveRecord::Base 

  searchkick word_start: [:body]
  before_create :sanitize_site 


  def sanitize_site 
   if !self.site.include?("backpage.com") || self.site.nil?
    self.site = "backpage.com"
   else 
    ActionController::Base.helpers.sanitize(self.site)
   end 
  end 


  def self.filtered_csv(backpage)
    CSV.generate do |csv| 
      csv << ["Title", "Body", "Image"]
      backpage.each do |backpage| 
        csv << [backpage.title, backpage.body, backpage.image]
      end
    end 
  end 

  def self.to_csv
    CSV.generate do |csv| 
      csv << ["Title", "Body", "Image"]
      Backpage.all.each do |backpage| 
        csv << [backpage.title, backpage.body, backpage.image]
      end
    end 
  end 
end 



