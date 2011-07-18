class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @session = UserSession.new
  end
  


  def create
    
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to root_url
    else
      render :action => :new
    end
  end



  def destroy
    flash[:notice] = "Logout successful!"
    current_user_session && current_user_session.destroy
  end
end
