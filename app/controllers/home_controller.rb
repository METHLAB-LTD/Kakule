class HomeController < ApplicationController
  def index
    @date = format_date(Time.now)
    find_or_create_guest_user
    @itinerary = find_or_create_itinerary
  end
end
