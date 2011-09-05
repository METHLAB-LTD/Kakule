class ItineraryTag < ActiveRecord::Base
  belongs_to :itinerary
  belongs_to :tag
  
  validates_uniqueness_of :tag_id, :scope => :itinerary_id
  
end
