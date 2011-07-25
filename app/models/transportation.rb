class Transportation < ActiveRecord::Base
  belongs_to :itinerary
  
  @@modes = {
    0 => "None",
    1 => "Plane",
    2 => "Own Car",
    3 => "Rental Car",
    4 => "ZipCar",
    5 => "Watercraft",
    6 => "Bicycle"
  }
  
  # in meters/hour
  @@speeds = {
    :drive => 112654.08,
    :walk => 8046.72
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
    
    distances = Array.new(sorted_timeline.length - 1)
    i=0
    sorted_timeline.each_cons(2) do |from, to|
      distances[i] = {
        :meters => KakuleHelper.geo_distance(from[:lat], from[:lng], to[:lat], to[:lng]),
        :seconds => to[:start_time] - from[:end_time]
      }
      i+=1
    end
    
    distances.map! do |dist|
      if (dist[:seconds] < 60)
        if dist[:meters] < 15000
          :walk
        elsif dist[:meters] < 500000
          :drive
        else
          :fly
        end
      else
        if (dist[:meters] / @@speeds[:walk]) + 24.0 * ((dist[:meters] / @@speeds[:walk]) / MOVING_HOURS_PER_DAY).floor < dist[:seconds]/3600
          :walk
        elsif (dist[:meters] / @@speeds[:drive]) + 24.0 * ((dist[:meters] / @@speeds[:drive]) / MOVING_HOURS_PER_DAY).floor < dist[:seconds]/3600
          :drive
        else
          :fly
        end
        
      end
    end
    
    return distances
  end
  
end
