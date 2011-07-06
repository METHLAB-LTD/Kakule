class Event < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :eventful_id, :allow_nil => true
  @@default_radius = 10
  @@default_search_page = 20
  
  def self.find_by_custom_params(params)
    params[:radius] = @@default_radius if params[:radius].nil?
    params[:limit] = @@default_search_page if params[:radius].nil?
    params[:end_time] = Time.now + 1.day if params[:end_time].nil?
    params[:start_time] = Time.now if params[:start_time].nil?
    
    find(:all, 
      :conditions => ["(latitude between ? and ?) AND (longitude between ? and ?) 
        AND ((name LIKE ?) OR (description LIKE ?)) 
        AND (start_time < ? AND (end_time > ? OR end_time = ?))", 
        params[:lat].to_i - params[:radius].to_i, params[:lat].to_i + params[:radius].to_i, params[:long].to_i - params[:radius].to_i, params[:long].to_i + params[:radius].to_i,
        "%#{params[:query]}%",  "%#{params[:query]}%",
        Time.parse(params[:end_time]), Time.parse(params[:start_time]), nil
      ], :limit => params[:limit].to_i)
    
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
