require "csv"
class Recycler < ActiveRecord::Base 
  searchkick word_start: [:body]

  before_save :sanitize_site 


  def sanitize_site 
   if !self.site.include?("recycler.com")
    self.site = "recycler.com"
   else 
    ActionController::Base.helpers.sanitize(self.site)
   end 
  end 

  def self.filtered_csv(recycler)
    CSV.generate do |csv| 
      csv << ["Title", "Body", "Advertiser", "Image"]
      recycler.each do |recycler| 
        csv << [recycler.brand, recycler.description, recycler.number, recycler.image]
      end
    end 
  end

  def self.to_csv
    CSV.generate do |csv| 
      csv << ["Title", "Body", "Advertiser", "Image"]
      Recycler.all.each do |recycler| 
        csv << [recycler.title, recycler.body, recycler.advertiser, recycler.image]
      end
    end 
  end 
end
