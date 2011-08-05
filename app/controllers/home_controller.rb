class HomeController < ApplicationController
  def index
    @date = format_date(Time.now)
    find_or_create_guest_user
    @itinerary = current_itinerary(:include => [:selected_events, :events, :selected_attractions, :attractions, :transportations])
    @timeline = current_itinerary.timeline
    @events = current_itinerary.events
  end
end
