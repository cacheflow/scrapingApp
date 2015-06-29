class ConstructionsController < ApplicationController
  include ConstructionsHelper

  def new
    @construction = Construction.new(construction_params)
  end

  def create
    @construction = Construction.new(construction_params)
    if @construction.site.include?("mascus.com")
       @construction.save 
      redirect_to construction_path(@construction)
    else 
      render :new
    end 
  end 

  def index
    if params[:search].present?
      @constructions = Construction.search(params[:search])
      respond_to do |format| 
        format.html 
        format.csv {render text: ActionController::Base.helpers.sanitize(Construction.all.filtered_csv(@constructions))}
      end
    else 
      @constructions = Construction.all
      respond_to do |format|
        format.html
        format.csv {render text: ActionController::Base.helpers.sanitize(@constructions.to_csv)}
      end
    end
  end

  def update 
    @construction = Craigslist.find(params[:id])
    if @construction.update(craigslist_params)
      redirect_to construction_path(@construction) 
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
    @construction = Construction.find(params[:id])
    @headless = Headless.new
    @scraper = Scraper.new 
    @scraper.start("#{@construction.site}")
    @headless.destroy
    @scraper.close
    redirect_to constructions_path and return
  end  
   


   

   
   


  def construction_params
      params.fetch(:construction, {}).permit(:site)
  end
end