  class BackpageValidator < ActiveModel::Validator
    attr_reader :backpage 

    def initialize(backpage)
      @backpage = backpage 
    end 

    def validate(backpage)
      if !backpage.site.include?("backpage.com")
        backpage.errors.add_to_base("This url is not a valid backpage link.")
      end 
    end 
  end



