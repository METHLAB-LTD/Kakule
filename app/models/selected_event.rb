class SelectedEvent < ActiveRecord::Base
  belongs_to :itinerary
  belongs_to :event
end
