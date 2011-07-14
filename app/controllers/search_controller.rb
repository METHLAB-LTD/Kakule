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
    # render :json => geocodes

    # Return in Ruby format because we want rails to do the
    # partial generation 
  end

  # Render partial UI for geocoding results
  def render_geocoding
    results = geocoding
    render :json => {
        :html => (render_to_string :partial => "geocoding", :locals => {:data => results})
    }
  end
  
  # POST /search/flights
  # params => {from : "SFO", to : "HKG", departure_date : (new Date(2011,8,2)).toLocaleString(), return_date : (new Date(2011,8,20)).toLocaleString()} 
  # optional_params => {adults : 1}
  def flights
    render :json => Expedia::Air.flight_info(params).to_json
  end
  
  # POST /search/hotels
  # params = {latitude : "037.000000", longitude : "122.000000", arrivalDate : "10/18/2011", departureDate : "10/20/2011", searchRadius : 50, searchRadiusUnit : "MI"}
    
  def hotels
    render :json => Expedia::Hotel.search_by_coordinate(params).to_json
  end
  
  # POST /search/cars
  # params = {rentals : {cityCode: "LAX", classCode: "S", dropOffDate: "8/26/2011", dropOffTime: "9AM", pickUpDate: "8/22/2011", pickUpTime: "9PM", sortMethod: "0"}}
  def cars
    render :json => {
      :rentals => Expedia::Car.rentals(params[:rentals]),
      :zipcar => false
    }.to_json
  end

end
