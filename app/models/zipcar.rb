class Zipcar < ActiveRecord::Base
  
  validates_presence_of :location
  
  def self.has_car?(airport_code)
    !!find_by_closest_airport(airport_code)
  end
  
end
