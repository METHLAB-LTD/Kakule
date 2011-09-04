class Transportation < ActiveRecord::Base
  #belongs_to :itinerary
  # Stand alone class for now. Have it point to other classes like Flights later. Maybe.
  has_one :itinerary_item, :foreign_key => "location_id", :conditions => "itinerary_items.location_type = 'Transportation'"
  has_one :itinerary, :through => :itinerary_item
  #validates_uniqueness_of :start_time, :scope => :itinerary_id
  
  @@modes = {
    0 => "None",
    1 => "Plane",
    2 => "Own Car",
    3 => "Rental Car",
    4 => "Taxi",
    5 => "ZipCar",
    6 => "Watercraft",
    7 => "Bicycle",
    8 => "Walk"
  }
  
  # in meters/hour
  @@speeds = {
    :drive => 112654.08,
    :walk => 8046.72,
    :fly => 805000.0
  }
  MOVING_HOURS_PER_DAY = 8.0
  
  
  def name
    @@modes[mode]
  end
  
  def self.recommend_transport(meters, seconds)
    walking_duration = (meters / @@speeds[:walk]) + 24.0 * ((meters / @@speeds[:walk]) / MOVING_HOURS_PER_DAY).floor
    driving_duration = (meters / @@speeds[:drive]) + 24.0 * ((meters / @@speeds[:drive]) / MOVING_HOURS_PER_DAY).floor 
    flying_duration = (meters / @@speeds[:fly]) + 24.0 * ((meters / @@speeds[:fly]) / MOVING_HOURS_PER_DAY).floor
    
    if (seconds < 60 && meters < 15000) || (walking_duration < seconds/3600)
      return {:duration => walking_duration.hours, :mode => 8}
    elsif (seconds < 60 && meters < 500000) || (driving_duration < seconds/3600)
      return {:duration => driving_duration.hours, :mode => 4}
    else
      return {:duration => flying_duration.hours, :mode => 1}
    end
  end
end
