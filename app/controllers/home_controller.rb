class HomeController < ApplicationController
  def index
    @date = Time.now
  end

end
