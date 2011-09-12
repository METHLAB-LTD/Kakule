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
  def events(limit)
    # TODO: Figure out how to limit the Yelp API calls,
    # instead of cutting the results off afterwards (less
    # efficient)
    @events = Event.find_by_custom_params(params)[0, limit]
    #@attractions = Attraction.find_by_custom_params(params)
    @attractions = Attraction.find_with_yelp(params)[0, limit]
    results = {:events => @events, :attractions => @attractions }
    
    #render :json => {
    #  :events => @events,
    #  :attractions => @attractions
    #}
  end

  def render_attractions
    results = events(5)
    results[:events].each {|e| e[:type] = "event" }
    results[:attractions].each {|a| a[:type] = "attraction" }

    # TODO: sort in order of importance, not events followed
    # by attractions
    all = results[:events].concat(results[:attractions])
    
    render :json => {
        :html => (render_to_string :partial => "attractions", :locals => {:all => all}),
        :query => params[:query]
    }
  end
  
  # POST /search/geocoding
  # Required: query
  # example = {"query" : "San Francisco"}
  def places
    #render :json => [] if params[:q].blank? #should let JS handle this eventually (at least 2 chars)
    #geocodes = Geocode.find_by_similar_name(params[:q])
    
    tags = Tag.where("name like ?", "%#{params[:q]}%")
    titles = Question.where("title like ?", "%#{params[:q]}%")
    render :json => tags.map {|tag| {:id => tag[:id], :name => tag.name, :type => "Tag"}} + titles.map {|g| {:id => g[:id], :name => g.title, :type => "Question"}}
    
    # render :json => {
    #   :tags => tags.map {|tag| {:name => tag.name, :type => "Tag"}},
    #   :questions => titles.map {|g| {:name => g.title}}
    # }
    
    #render :json => geocodes.map {|g| {:name => g.full_name, :id => g.id, :lat => g.latitude, :lng => g.longitude } }
    
    # Return in Ruby format because we want rails to do the
    # partial generation 
  end

  # Render partial UI for geocoding results
  def render_place_by_id
    geocode = Geocode.find(params[:id].to_i)
    photos = geocode.photos(10)
    render :json => {
        :html => (render_to_string :partial => "place", :locals => {:place => geocode, :photos => photos}),
        :photos => photos.map {|p| p[:url]}
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
  def meals(limit)
    # TODO: Figure out how to set limit w/ Yelp API
    # instead of cutting the array off after (less
    # efficient)
    params[:category] = ["food", "restaurants"]
    meals = Attraction.find_with_yelp(params)[0, limit]
    meals.map {|m| m["type"] = "meal"}
    return meals
  end
  
  def render_meals
    meals = meals(5)
    render :json => {
      :html => render_to_string(:partial => "attractions", :locals => {:all => meals})
    }.to_json
  end
  
  # POST /search/photos
  # Required:
  # Optional:
  # 
  # Possible fields: http://www.flickr.com/services/api/flickr.photos.search.html
  def photos
    return Flikr::Photos.new.search(params)
  end
  
  
  def render_photos
    render :json => {
      :html => render_to_string(:partial => "photos", :locals => {:photos => photos})
    }.to_json
    
  end


end
