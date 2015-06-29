class PenniesController < ApplicationController
  include PenniesHelper
  def new
    @penny = Penny.new(penny_params)
  end

  def create
    @penny = Penny.new(penny_params)
    if @penny.save 
      redirect_to penny_path(@penny)
    else 
      render :new
    end 
  end 

  def index
    if params[:search].present? 
      @pennys = Penny.search(params[:search])
      respond_to do |format| 
        format.html 
          format.csv {render text: ActionController::Base.helpers.sanitize(Penny.all.filtered_csv(@pennys))}
      end      
    else 
      @pennys = Penny.all  
      respond_to do |format| 
          format.html
          format.csv {render text: ActionController::Base.helpers.sanitize(@pennys.to_csv)}
      end 
    end
  end  
  

  def update 
    @penny = Penny.find(params[:id])
    if @penny.update(penny_params)
      redirect_to penny_path 
    else 
      render :edit 
    end 
  end 
    

  def edit
  end

  def destroy
  end

  def find
  end

  def show
    @penny = Penny.find(params[:id])
    @scraper = Scraper.new
    @scraper.start("#{@penny.site}") 
    redirect_to pennies_path and return
  end 
        

       
 protected        
  def penny_params
      params.fetch(:penny, {}).permit(:site)
  end
end

