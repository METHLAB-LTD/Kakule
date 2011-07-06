class SearchController < ApplicationController
  
  
  # POST /search/events
  # params => {"lat" : 25, "long" : -120, "radius" : 50, "query" : "ass", "start_time" : (new Date()).toLocaleString(), "end_time" : (new Date(2011,7,2)).toLocaleString()}
  def events
    #validate_time_range
    
    params[:radius] = 10 if params[:radius].nil?
    params[:end_time] = Time.now + 1.day if params[:end_time].nil?
    params[:start_time] = Time.now if params[:start_time].nil?
    
    
    @events = Event.find(:all, 
      :conditions => ["(latitude between ? and ?) AND (longitude between ? and ?) 
        AND ((name LIKE ?) OR (description LIKE ?)) 
        AND (start_time < ? AND (end_time > ? OR end_time = ?))", 
        params[:lat].to_i - params[:radius].to_i, params[:lat].to_i + params[:radius].to_i, params[:long].to_i - params[:radius].to_i, params[:long].to_i + params[:radius].to_i,
        "%#{params[:query]}%",  "%#{params[:query]}%",
        Time.parse(params[:end_time]), Time.parse(params[:start_time]), nil
      ], :limit => 20)
    
    render :json => {
      :events => @events
    }
    
  end
  
  # POST /search/location
  # params => {"lat" : 25, "long" : -120, "ip" : "255.255.255.255"}
  def location
    if (params[:lat] && params[:long])
      data = SimpleGeo::Client.get_context(params[:lat], params[:long])
    elsif (params[:ip])
      data = SimpleGeo::Client.get_context_ip(params[:ip])
    else
      data = nil  
    end
    location = data[:address][:properties][:city] rescue nil
    
    render :json => {:location => location}
  end
  
  # POST /search/geocoding
  # params => {"query" : "San Francisco"}
  def geocoding
    geocodes = Geocode.find_by_similar_name(params[:query])
    render :json => geocodes
  end
  
  
  private
  def validate_time_range
    if (Time.parse(params[:start_time]) > Time.parse(params[:end_time]) )
      render :json => {:error => "invalid time range"}
    end
  end
  
  
  
end
