class HomeController < ApplicationController
  before_filter :set_page
  
  def index
    time = Time.now.at_beginning_of_day
    @date = format_date(time)
    find_or_create_guest_user
    @itinerary = current_itinerary(:include => [:selected_events, :events, :selected_attractions, :attractions, :transportations])
    puts current_user
    puts current_user.id
    puts current_user.itineraries
    puts @itinerary
    @timeline = current_itinerary.timeline

    @events = current_itinerary.get_events(time)
    @attractions = current_itinerary.get_attractions(time)
  end
  
  def set_page
    @page = "home"
  end
end
