class Tag < ActiveRecord::Base
  has_many :itinerary_tags
  has_many :itineraries, :through => :itinerary_tags
end
