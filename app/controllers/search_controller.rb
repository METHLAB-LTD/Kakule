class SearchController < ApplicationController
  
  
  # POST /search/locations
  # params => {"lat" : 25, "long" : -120, "ip" : "255.255.255.255"}
  def locations
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
  
  # POST /search/events
  # params => {"lat" : 25, "long" : -120, "radius" : 50, "query" : "ass", "start_time" : (new Date()).toLocaleString(), "end_time" : (new Date(2011,7,2)).toLocaleString(), "limit" : 20}
  def events
    @events = Event.find_by_custom_params(params)
    @attractions = Attraction.find_by_custom_params(params)
    
    render :json => {
      :events => @events,
      :attractions => @attractions
    }
  end

  
  # POST /search/geocoding
  # params => {"query" : "San Francisco"}
  def geocoding
    geocodes = Geocode.find_by_similar_name(params[:query])
    render :json => geocodes
  end

end
