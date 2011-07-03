class CalendarEvent < ActiveRecord::Base
  has_event_calendar
  belongs_to :itinerary
  
end
