class BackpagesController < ApplicationController
  include BackpagesHelper

  def new
    @backpage = Backpage.new(backpage_params)
  end

  def create
    @backpage = Backpage.new(backpage_params)
    if @backpage.save 
      redirect_to backpage_path(@backpage)
    else 
      render :new
    end 
  end 

  def index
    if params[:search].present? 
      @backpages = Backapage.all 
      respond_to do |format| 
        format.html 
          format.csv {render text: ActionController::Base.helpers.sanitize(Backpage.all.filtered_csv(@backpages))}
      end       
    else 
      @backpages = Backpage.all 
      respond_to do |format| 
          format.html
          format.csv {render text: ActionController::Base.helpers.sanitize(@backpages.to_csv)}
      end 
    end
  end  
  

  def update 
    @backpage = Backpage.find(params[:id])
    if @backpage.update(backpage_params)
      redirect_to backpage_path 
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
    @backpage = Backpage.find(params[:id])
    # @headless = Headless.new
    # @headless.start
    @scraper = Scraper.new
    @scraper.start("#{@backpage.site}") 
    redirect_to backpage_path and return
  end 
        

       
 protected        
  def backpage_params
      params.fetch(:backpage, {}).permit(:site)
  end
end
