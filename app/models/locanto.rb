require "csv"
class Locanto < ActiveRecord::Base
  before_save :sanitize_site 
  searchkick

  def sanitize_site 
   if !self.site.include?("locanto.com")
    self.site = "locanto.com"
   else 
    ActionController::Base.helpers.sanitize(self.site)
   end 
  end  

  def self.filtered_csv(locanto)
    CSV.generate do |csv| 
      csv << ["Title", "Body", "Image", "Number"]
      Locanto.each do |locanto| 
        csv << [locanto.title, locanto.body, locanto.image, locanto.number]
      end
    end 
  end

  def self.to_csv
    CSV.generate do |csv| 
      csv << ["Title", "Body", "Image", "Number"]
      Locanto.all.each do |locanto| 
        csv << [locanto.title, locanto.body, locanto.image, locanto.number]
      end
    end 
  end 

end
