class SelectedEvent < ActiveRecord::Base
  belongs_to :itinerary
  belongs_to :event
  validates_presence_of :start_time, :end_time
end
