require "application_responder"
class ApplicationController < ActionController::Base
  # self.responder = ApplicationResponder
  # respond_to :html
  before_action :authenticate_user!
  # # Prevent CSRF attacks by raising an exception.
  # # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ApplicationHelper 
  
  # def session_create 
  #   session[:remember_token] = @user.id 
  #   @current_user = @user
  # end 

  # def authenticate_user 
  #   unless self.current_user 
  #   end
  # end 

  

   
end
