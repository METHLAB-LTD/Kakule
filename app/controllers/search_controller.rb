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
  
  # POST /search/flights
  # params => {:from => "SFO", :to => "HKG", :departure_date => Time.now + 3.days, :return_date => Time.now + 9.days, :adults => 1 (optional)}
  def flights
    render :json => Expedia::Air.flight_info(params).to_json
    
  end
  
  # POST /search/hotels
  # params => {:latitude => "037.000000", :longitude => "122.000000", :searchRadius => "50", :searchRadiusUnit => "MI", :arrivalDate => "10/18/2011", :departureDate => "10/20/2011", :numberOfResults => 50}
  
  def hotels
    render :json => Expedia::Hotel.search_by_coordinate(params).to_json
  end
  # POST /search/cars
  # params => {:cityCode => "LAX", :pickUpDate => "8/22/2011", :dropOffDate => "8/26/2011", :classCode => "S", :pickUpTime => "9PM", :dropOffTime => "9AM", :sortMethod => "0"}
  def cars
    Expedia::Car.rentals(params[:rental])
  end
  
  # POST /search/hotels
  # params => {"query" : "San Francisco"}
  # def hotels
  #   url = "http://sandbox.hotelscombined.com/API/Search.svc/pox/CitySearch?ApiKey=#{HOTELS_COMBINED_API_KEY}&UserID#{HOTELS_COMBINED_USER_ID}&UserAgent=Internet%20Explorer&UserIPAddress=127.0.0.1&CityID=5766&Checkin=2010-12-10&Checkout=2010-12-25&Guests=1&Rooms=1&AvailableOnly=true"
  # end
  
  
  

end
