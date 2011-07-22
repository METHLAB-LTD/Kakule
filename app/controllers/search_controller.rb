class SearchController < ApplicationController
  
  
  # POST /search/locations
  # Required: either lat and lng or ip
  # params => {"lat" : 25, "lng" : -120, "ip" : "255.255.255.255"}
  def locations
    if (params[:lat] && params[:lng])
      RAILS_DEFAULT_LOGGER.info("[API] SimpleGeo Coords")
      data = SimpleGeo::Client.get_context(params[:lat], params[:lng])
    elsif (params[:ip])
      RAILS_DEFAULT_LOGGER.info("[API] SimpleGeo IP")
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
    #@attractions = Attraction.find_by_custom_params(params)
    RAILS_DEFAULT_LOGGER.info("[API] Yelp")
    client  = Yelp::Client.new
    request = Yelp::Review::Request::GeoPoint.new(
     :latitude => params[:lat],
     :longitude => params[:lng],
     :radius => 20,
     :term => params[:query],
     :category => params[:category] || ["amusementparks"],
     :yws_id => YELP_API_KEY)
    @attractions = client.search(request)["businesses"]

    results = {:events => @events, :attractions => @attractions }
    
    #render :json => {
    #  :events => @events,
    #  :attractions => @attractions
    #}
  end

  def render_attractions
    results = events
    
    render :json => {
        :html => (render_to_string :partial => "attractions", :locals => {:event_data => results[:events], :attraction_data => results[:attractions]}),
        :query => params[:query]
    }
  end
  
  # POST /search/geocoding
  # Required: query
  # example = {"query" : "San Francisco"}
  def geocoding
    return [] if params[:query].blank? #should let JS handle this eventually (at least 2 chars)
    geocodes = Geocode.find_by_similar_name(params[:query])
    # render :json => geocodes

    # Return in Ruby format because we want rails to do the
    # partial generation 
  end

  # Render partial UI for geocoding results
  def render_geocoding
    results = geocoding
    render :json => {
        :html => (render_to_string :partial => "geocoding", :locals => {:data => results}),
        :data => results,
        :query => params[:query]
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
      :zipcar => !!(Zipcar.has_car?(params[:pickUpCity]) if params[:dropOffCity].blank?) #zipcar can't be returned at another city
    }.to_json
  end
  
  
  # POST /search/meals
  # Required: lat, lng
  # Optional: radius (miles), query, category
  # 
  # Possible Categories: http://www.yelp.com/developers/documentation/category_list
  def meals
    client  = Yelp::Client.new
    RAILS_DEFAULT_LOGGER.info("[API] Yelp")
    request = Yelp::Review::Request::GeoPoint.new(
     :latitude => params[:lat],
     :longitude => params[:lng],
     :radius => params[:radius],
     :term => params[:query],
     :category => params[:category] || ["food", "restaurants"],
     :yws_id => YELP_API_KEY)
    render :json => client.search(request).to_json
  end
  
  # POST /search/photos
  # Required:
  # Optional:
  # 
  # Possible fields: http://www.flickr.com/services/api/flickr.photos.search.html
  def photos
    render :json => {
      :photos => Flikr::Photos.new.search(params)
    }
  end
  
  

end
