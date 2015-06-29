class CraigslistsController < ApplicationController
  include CraigslistHelper
  def new
    @craigslist = Craigslist.new(craigslist_params)
  end

  def create
    @craigslist = Craigslist.new(craigslist_params)
    if @craigslist.site.include?("craigslist.org")
        @craigslist.save 
      redirect_to craigslist_path(@craigslist)
    else 
      render :new
    end 
  end 

  def index
    if params[:search].present? 
      @craigslists = Craigslist.search(params[:search])
      respond_to do |format| 
        format.html 
          format.csv {render text: ActionController::Base.helpers.sanitize(Craigslist.all.filtered_csv(@craigslists))}
      end      
    else 
      @craigslists = Craigslist.all  
      respond_to do |format| 
          format.html
          format.csv {render text: ActionController::Base.helpers.sanitize(@craigslists.to_csv)}
      end 
    end
  end  
  

  def update 
    @craigslist = Craigslist.find(params[:id])
    if @craigslist.update(craigslist_params)
      redirect_to craigslist_path 
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
    @craigslist = Craigslist.find(params[:id])
    @scraper = Scraper.new(:chrome)
    @scraper.start("#{@craigslist.site}") 
    @scraper.close
    redirect_to craigslists_path and return
  end 
        

       
 protected        
  def craigslist_params
      params.fetch(:craigslist, {}).permit(:site)
  end
end

