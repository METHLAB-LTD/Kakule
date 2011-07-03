class Event < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :eventful_id, :allow_nil => true
  
  
  def coordinate
    return [self[:latitute], self[:longitude]]
  end
  
  
  def self.store_eventful_data(events)
    events.each do |event|
      Event.create({
        :eventful_id  => event["id"],
        :name         => event["title"],
        :description  => event["description"],
        :start_time   => event["start_time"].blank? ? nil : Time.parse(event["start_time"]),
        :end_time     => event["stop_time"].blank? ? nil : Time.parse(event["stop_time"]),
        :venue        => event["venue_name"],
        :street       => event["venue_address"],
        :city         => event["city_name"],
        :state        => event["region_name"],
        :postal       => event["postal_code"],
        :country      => event["country_abbr"],
        :latitude     => event["latitude"].to_f,
        :longitude    => event["longitude"].to_f,
        :picture_url  => event["image"].blank? ? nil : event["image"]["url"]
      })
    end
  end
  
end
