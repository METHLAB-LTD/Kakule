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
end
