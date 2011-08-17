class SelectedMeal < ActiveRecord::Base
  belongs_to :itinerary
  belongs_to :attraction
  validates_presence_of :start_time, :end_time
end
