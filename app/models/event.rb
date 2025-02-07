class Event < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :eventful_id, :allow_nil => true
  
  has_many :likes, :as => :likable
  
  
  @@default_radius = 1
  @@default_search_page = 20
  
  def self.find_by_custom_params(params)
    params[:limit] ||= @@default_search_page
    params[:end_time] = params[:end_time].nil? ? Time.now + 1.day : Time.parse(params[:end_time])
    params[:start_time] = params[:start_time].nil? ? Time.now : Time.parse(params[:start_time])
    params[:query] ||= ""

    results = []
    if !params[:lat].blank? && !params[:lng].blank?
      params[:radius] ||= @@default_radius
      results = find(:all, 
        :conditions => ["(latitude between ? and ?) AND (longitude between ? and ?) 
          AND ((name LIKE ?) OR (description LIKE ?)) 
          AND (start_time < ? AND (end_time > ? OR end_time = ?))", 
          params[:lat].to_f - params[:radius].to_f, params[:lat].to_f + params[:radius].to_f, params[:lng].to_f - params[:radius].to_f, params[:lng].to_f + params[:radius].to_f,
          "%#{params[:query]}%",  "%#{params[:query]}%",
        
          params[:end_time], 
          params[:start_time], 
          nil
        ], :limit => params[:limit].to_i, :include => :likes)
      else
        results = find(:all, 
          :conditions => ["(name LIKE ?) AND (start_time < ? AND (end_time > ? OR end_time = ?))",
            "%#{params[:query]}%",
            params[:end_time], 
            params[:start_time], 
            nil
          ], :limit => params[:limit].to_i, :include => :likes)
      end
      
      return results.sort{|a,b| b.likes.length <=> a.likes.length}
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
