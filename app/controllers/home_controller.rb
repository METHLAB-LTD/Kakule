class HomeController < ApplicationController
  def index
    @date = Time.now
    find_or_create_guest_user
    @itinerary = find_or_create_itinerary
  end
end
