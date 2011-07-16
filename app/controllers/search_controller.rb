class SearchController < ApplicationController
  
  
  # POST /search/locations
  # Required: either lat and lng or ip
  # params => {"lat" : 25, "lng" : -120, "ip" : "255.255.255.255"}
  def locations
    if (params[:lat] && params[:lng])
      data = SimpleGeo::Client.get_context(params[:lat], params[:lng])
    elsif (params[:ip])
      data = SimpleGeo::Client.get_context_ip(params[:ip])
    else
      data = nil  
    end
    location = data[:address][:properties][:city] rescue nil
    
    render :json => {:location => location}
  end
  
  # POST /search/events
  # Required: lat, lng
  # Optional: radius, query, start_time, end_time, limit
  # example = {lat : 37.782455, lng : -122.405855, radius : 50, query : "ass", start_time : (new Date()).toLocaleString(), end_time : (new Date(2011,7,2)).toLocaleString(), limit : 20}
  def events
    @events = Event.find_by_custom_params(params)
    @attractions = Attraction.find_by_custom_params(params)
    
    render :json => {
      :events => @events,
      :attractions => @attractions
    }
  end
  
  # POST /search/geocoding
  # Required: query
  # example = {"query" : "San Francisco"}
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
  # Required: from, to, departure_date
  # Optional: return_date, adults
  # example = {from : "SFO", to : "HKG", departure_date : (new Date(2011,8,2)).toLocaleString(), return_date : (new Date(2011,8,20)).toLocaleString()} 
  def flights
    render :json => Expedia::Air.flight_info(params).to_json
  end
  
  # POST /search/hotels
  # Required: lat, lng, arrival_date, departure_date
  # Optional: radius
  # example = {lat : "37.000000", lng : "122.000000", arrival_date : "10/18/2011", departure_date : "10/20/2011", searchRadius : 50, searchRadiusUnit : "MI"}
  def hotels
    params[:latitude] = "%6f" % params[:lat]
    params[:longitude] = "%6f" % params[:lng]
    params[:arrivalDate] = Time.parse(params[:arrival_date]).strftime("%m/%d/%Y")
    params[:departureDate] = Time.parse(params[:departure_date]).strftime("%m/%d/%Y")
    params[:searchRadius] = params[:radius]
    
    render :json => Expedia::Hotel.search_by_coordinate(params).to_json
  end
  
  # POST /search/cars
  # Required: pickUpCity, pickUpDate, pickUpTime, dropOffDate, dropOffTime
  # Optional: dropOffCity, classCode, typeCode, sortMethod, currencyCode, corpDiscountCode, promoCouponCode
  # Docs: http://developer.ean.com/docs/read/car_rentals/cars_200820/resources/get_available_cars
  # 
  # example = {pickUpCity: "LAX", dropOffDate: "8/26/2011", dropOffTime: "9AM", pickUpDate: "8/22/2011", pickUpTime: "9PM"}
  def cars
    params[:cityCode] = params[:pickUpCity]
    params[:dropOffCode] = params[:dropOffCity]
    
    render :json => {
      :rentals => Expedia::Car.rentals(params),
      :zipcar => false
    }.to_json
  end

end
