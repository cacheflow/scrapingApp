class RecyclersController < ApplicationController
    include RecyclersHelper

  def new
    @recycler = Recycler.new(recycler_params)
  end

  def create
    @recycler = Recycler.new(recycler_params)
    if @recycler.site.include?("recycler.com")
        @recycler.save 
      redirect_to recycler_path(@recycler)
    else 
      render :new
    end 
  end 

  def index
    if params[:search].present? 
      @recyclers = Recycler.search(params[:search])
      respond_to do |format| 
        format.html 
          format.csv {render text: ActionController::Base.helpers.sanitize(Recycler.all.filtered_csv(@recyclers))}
      end      
    else 
      @recyclers = Recycler.all  
      respond_to do |format| 
          format.html
          format.csv {render text: ActionController::Base.helpers.sanitize(@recyclers.to_csv)}
      end 
    end
  end  
  

  def update 
    @recycler = Recycler.find(params[:id])
    if @recycler.update(recycler_params)
      redirect_to recycler_path 
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
    @recycler = Recycler.find(params[:id])
    # @headless = Headless.new
    # @headless.start
    @scraper = Scraper.new(:chrome)
    if @recycler.pages.nil?
      @recycler.pages = 1 
    else 
      @recycler.pages = @recycler.pages
    end 
    @scraper.start("#{@recycler.site}", @recycler.pages.to_i) 
    # @recycler.pages.tr("^0-9$", "").to_i
    # @headless.destroy
    redirect_to recyclers_path and return
  end 
        

       
 protected        
  def recycler_params
      params.fetch(:recycler, {}).permit(:site, :pages)
  end
end
