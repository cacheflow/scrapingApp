class LocantosController < ApplicationController
   include LocantosHelper

   def new
    @locanto = Locanto.new(locanto_params)
   end

  def create
    @locanto = Locanto.new(locanto_params)
    if @locanto.save 
      @scraper = Scraper.new 
      @scraper.start("#{params[:locanto][:site]}", params[:locanto][:pages])
      redirect_to locantos_path
    else 
      render :new
    end 
  end 

  def index
    if params[:search].present? 
      @locantos = Locanto.search(params[:search])
      respond_to do |format| 
        format.html 
          format.csv {render text: ActionController::Base.helpers.sanitize(Locanto.all.filtered_csv(@locantos))}
      end      
    else 
      @locantos = Locanto.all  
      respond_to do |format| 
          format.html
          format.csv {render text: ActionController::Base.helpers.sanitize(@locantos.to_csv)}
      end 
    end
  end  
  
      

 protected        
  def locanto_params
      params.fetch(:locanto, {}).permit(:site, :pages)
  end
end


