class Transportation < ActiveRecord::Base
  belongs_to :itinerary
  validates_uniqueness_of :start_time, :scope => :itinerary_id
  
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
  
  def self.recommend(itinerary)
    timeline = itinerary.raw_timeline
    # need to sanitize: remove/disregard time blocks if n[:end_time] > n+1[:start_time]
    # assuming non-overlaps in time blocks...
    sorted_timeline = timeline.map{|k, v| v}.flatten.sort{|a, b| a[:start_time] <=> b[:start_time]}
    
    sorted_timeline.each_cons(2) do |from, to|
      duration = to[:start_time] - from[:end_time]
      recommendation = recommend_transport(KakuleHelper.geo_distance(from[:lat], from[:lng], to[:lat], to[:lng]), duration)
      
      Transportation.create({
        :start_time => from[:end_time],
        :end_time => from[:end_time] + recommendation[:duration],
        :itinerary => itinerary,
        :mode => recommendation[:mode]
      })
    end
    
    return itinerary.add_transportation(timeline)
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
