class HomeController < ApplicationController
  def index
    @date = format_date(Time.now)
    find_or_create_guest_user
    @itinerary = current_itinerary
    @events = current_itinerary.events
  end
end
