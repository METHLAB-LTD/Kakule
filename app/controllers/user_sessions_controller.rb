class UserSessionsController < ApplicationController
  def new
    @session = UserSession.new
  end

  def destroy
    current_user_session && current_user_session.destroy
  end
end
