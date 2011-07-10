class HomeController < ApplicationController
  def index
    @date = Time.now
    unless current_user
      User.create(:is_guest => true)
    end
  end
end
