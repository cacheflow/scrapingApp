require "csv"
class Construction < ActiveRecord::Base 
  searchkick word_start: [:body]
  before_save :sanitize_site 


  def sanitize_site 
   if !self.site.include?("mascus.com") || !self.site.include?("mascus.com.mx")
    self.site = "mascus.com"
   else 
    ActionController::Base.helpers.sanitize(self.site)
   end 
  end 

  def self.filtered_csv(construction)
    CSV.generat(encoding: "utf-8") do |csv| 
      csv << ["Brand", "Description", "Number", "Image"]
      construction.each do |construct| 
        csv << [construct.brand, construct.description, construct.number, construct.image]
      end
    end 
  end

  def self.to_csv
    CSV.generate(encoding: "utf-8") do |csv| 
      csv << ["Brand", "Description", "Number", "Image"]
      Construction.all.each do |construct| 
        csv << [construct.brand, construct.description, construct.number, construct.image]
      end
    end 
  end 
end
