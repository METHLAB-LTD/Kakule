module Expedia
  CURL_TIMEOUT = 5
  
  module Air
    #p = {:from => "SFO", :to => "HKG", :departure_date => Time.now + 3.days, :return_date => Time.now + 9.days, :adults => 1}
    AIR_URL = "http://api.ean.com/ean-services/rs/air/200919/xmlinterface.jsp?cid=#{EXPEDIA_CID}&resType=air&intfc=ws&apiKey=#{EXPEDIA_AIR_API_KEY}&xml="
  
    def self.flight_info(params)
      sanitize_params(params)
      return nil if params[:return_date] < Time.now + 2.days
      
      xml = "<AirSessionRequest method='getAirAvailability'><AirAvailabilityQuery>"
      xml += trip_type(params[:return_date])
      xml += "<originCityCode>#{params[:from]}</originCityCode>
              <destinationCityCode>#{params[:to]}</destinationCityCode>
              <xmlResultFormat>2</xmlResultFormat>
              <searchType>2</searchType>
              <departureDateTime>#{format_date(params[:departure_date])}</departureDateTime>
              <Passengers>
                <adultPassengers>#{params[:adults]}</adultPassengers>
              </Passengers>"
      xml += "</AirAvailabilityQuery></AirSessionRequest>"
      parse(Expedia::Util.get(AIR_URL, xml))
    end
  
  
    private
    def self.trip_type(return_date)
      unless return_date.nil?
        return "<tripType>R</tripType><returnDateTime>#{format_date(return_date)}</returnDateTime>"
      else
        return "<tripType>O</tripType>"
      end
    end
    
    def self.format_date(date)
      date.strftime("%m/%d/%Y %I:%m %p")
    end
    
    def self.sanitize_params(params)
      params[:adults] = 1 if params[:adults].nil?
      params[:departure_date] = Time.parse(params[:departure_date])
      params[:return_date] = Time.parse(params[:return_date]) if params[:return_date]
      
      #TODO
    end
    
    def self.parse(xml)
      segment_list = {}
      flight_list = []
      xml.child.children.each do |elem|
        if elem.name == "SegmentList"
          elem.children.each do |segment|
            if segment.name == "Segment"
              segment_list[segment.attributes["key"].value] = Expedia::Util.extract_data(segment)
            end
          end
        elsif elem.name == "AirAvailabilityReply"
          flight_list << Expedia::Util.extract_data(elem)
        end
      end
      
      return {
        :segment_list => segment_list,
        :flight_list => flight_list
      }
    end
  end

  module Hotel
    HOTEL_URL = "http://api.ean.com/ean-services/rs/hotel/v3/"
    
    def self.search_by_coordinate(params)
      params.reject!{|k, v| not %w(arrivalDate departureDate latitude longitude searchRadius searchRadiusUnit numberOfResults).include?(k)}
      return if params["arrivalDate"].nil? || params["departureDate"].nil? || params["latitude"].nil? || params["longitude"].nil?
      params["searchRadius"] ||= "25"
      params["searchRadiusUnit"] ||= "MI"
      params["numberOfResults"] ||= "50"
      
      response = get_and_parse_json("list", params)
      return response["HotelListResponse"]
    end
    
    private
    def self.get_and_parse_json(method, params)
      url = HOTEL_URL + "#{method}?minorRev=6&cid=#{EXPEDIA_CID}&apiKey=#{EXPEDIA_HOTEL_API_KEY}&_type=json&locale=en_US&currencyCode=USD&" + params.to_query
      curl = Curl::Easy.new
      curl.connect_timeout = Expedia::CURL_TIMEOUT
      curl.url = url
      curl.http_get
      return JSON.parse(curl.body_str)
    end
      
  end


  module Car
    CAR_URL = "http://api.ean.com/ean-services/rs/car/200820/xmlinterface.jsp?cid=#{EXPEDIA_CID}&resType=car200820&intfc=ws&apiKey=#{EXPEDIA_CAR_API_KEY}&xml="
    # XML_TEMPLATE = "<CarSessionRequest method='getCarAvailability'>
    #    <CarAvailabilityQuery>
    #     <cityCode>[CITYCODE]</cityCode>
    #     <pickUpDate>[PICKUPDATE]</pickUpDate>
    #     <dropOffDate>[DROPOFFDATE]</dropOffDate>
    #     <classCode>[CLASSCODE]</classCode>
    #     <pickUpTime>[PICKUPTIME]</pickUpTime>
    #     <dropOffTime>[DROPOFFTIME]</dropOffTime>
    #     <sortMethod>[SORTMETHOD]</sortMethod>
    #     <currencyCode>[CURRENCYCODE]</currencyCode>
    #    </CarAvailabilityQuery>
    # </CarSessionRequest>"

 #   p = {:cityCode => "LAX", :pickUpDate => "8/22/2011", :dropOffDate => "8/26/2011", :classCode => "S", :pickUpTime => "9PM", :dropOffTime => "9AM", :sortMethod => "0"}
    def self.rentals(params)
      params.reject!{|k, v| not %w(cityCode pickUpDate dropOffDate pickUpTime dropOffTime companyCode classCode typeCode sortMethod currencyCode dropOffCode corpDiscountCode promoCouponCode).include?(k)}
      parse(Expedia::Util.get(CAR_URL, create_xml_request(params)))
    end
    
    def self.create_xml_request(params)
      "<CarSessionRequest method='getCarAvailability'><CarAvailabilityQuery>" + params.map{|k, v| Expedia::Util.construct_xml_node(k, v)}.join + "</CarAvailabilityQuery></CarSessionRequest>"
    end
    
    def self.parse(xml)
      return Expedia::Util.extract_data(xml.child)["CarAvailability"]
    end
    

  end
   
   
   
  module Util
    def self.get(url, xml)
      RAILS_DEFAULT_LOGGER.info("[API] Expedia: #{url}")
      curl = Curl::Easy.new
      curl.connect_timeout = Expedia::CURL_TIMEOUT
      curl.url = url + CGI.escape(xml)
      curl.http_get
      return Nokogiri::XML.parse(curl.body_str)
    end
    
    def self.extract_data(node)
      h = {}
      node.children.each do |elem|
        next if elem.name == 'text'
        insert = (elem.children.length > 1 ? extract_data(elem) : elem.text.strip)
        if h.key?(elem.name)
          h[elem.name].class == Array ? h[elem.name].push(insert) : h[elem.name] = [h[elem.name]].push(insert)
        else
          h[elem.name] = insert
        end
      end
      return h
    end
    
    def construct_xml_node(name, value)
      "<#{name}>#{value}</#{name}>"
    end
  end   
end