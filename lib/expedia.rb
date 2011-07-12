module Expedia
  #p = {:from => "SFO", :to => "HKG", :departure_date => Time.now + 3.days, :return_date => Time.now + 9.days, :adults => 1}
  CURL_TIMEOUT = 5
  module Air
    AIR_URL = "http://api.ean.com/ean-services/rs/air/200919/xmlinterface.jsp?cid=#{EXPEDIA_CID}&resType=air&intfc=ws&apiKey=#{EXPEDIA_API_KEY}&xml="
  
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
      parse(get(xml))
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
      #TODO
    end
    
    def self.get(xml)
      curl = Curl::Easy.new
      curl.connect_timeout = Expedia::CURL_TIMEOUT
      curl.url = AIR_URL + CGI.escape(xml)
      curl.http_get
      return Nokogiri::XML.parse(curl.body_str)
    end
    
    def self.parse(xml)
      segment_list = {}
      flight_list = []
      xml.child.children.each do |elem|
        if elem.name == "SegmentList"
          elem.children.each do |segment|
            if segment.name == "Segment"
              segment_list[segment.attributes["key"].value] = extract_data(segment)
            end
          end
        elsif elem.name == "AirAvailabilityReply"
          flight_list << extract_data(elem)
        end
      end
      
      return {
        :segment_list => segment_list,
        :flight_list => flight_list
      }
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
    

  end
end