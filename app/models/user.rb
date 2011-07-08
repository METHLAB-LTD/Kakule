class User < ActiveRecord::Base
  acts_as_authentic
  has_many :itineraries
  has_many :calendar_events, :through => :itineraries
  has_many :likes
  
  
  
  def can_read_itinerary?(itinerary)
    itinerary.owner == self || itinerary.permission_level >= Itinerary.permissions("Limited")
  end
  
  def can_update_itinerary?(itinerary)
    itinerary.owner == self
  end
  
  def can_destroy_itinerary(itinerary)
    itinerary.owner == self
  end
  
  
    
    
end
