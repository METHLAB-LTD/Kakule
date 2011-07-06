class SearchController < ApplicationController
  
  
  # POST /search/events
  # params => {"lat" : 25, "long" : -120, "radius" : 50, "query" : "ass", "start_time" : (new Date()).toLocaleString(), "end_time" : (new Date(2011,7,2)).toLocaleString(), "limit" : 20}
  def events
    #validate_time_range
    @events = Event.find_by_custom_params(params)
    
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
