module Flikr
  CURL_TIMEOUT = 5
  
  module Util
    def http_get(url)
      RAILS_DEFAULT_LOGGER.info("[API] Flikr: #{url}")
      curl = Curl::Easy.new
      curl.connect_timeout = Flikr::CURL_TIMEOUT
      curl.url = url
      curl.http_get
      return curl.body_str
    end
    
    def construct_url(photo, size=nil)
      return "http://farm#{photo["farm"]}.static.flickr.com/#{photo["server"]}/#{photo["id"]}_#{photo["secret"]}#{"_"+size if size}.jpg"
    end
    
  end
  
  class Photos
    include Flikr::Util
    

    def initialize
      
    end
    
    #Example
    #Flikr::Photos.new.search({"lat" => "48.85341", "lon" => "2.3488", "radius" => 20}).each{|a| puts a[:url]}
    def search(params)
      params = sanitize_params(params)
      params[:radius] ||= 20
      params[:radius_units] ||= "mi"
      params[:safe_search] ||= 1
      params[:sort] ||= "interestingness-desc"
      params[:content_type] ||= 1
      params[:media] = "photos"
      params[:in_gallery] ||= true
      params[:nojsoncallback] = 1
      params[:format] = "json"
      params[:extras] = "url_sq"
      url = "http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=#{FLIKR_API_KEY}&#{params.to_query}"
      puts url
      begin
        response = JSON.parse(http_get(url))
        response["photos"]["photo"].each do |photo| 
          photo[:url] = construct_url(photo)
          photo[:url_sq] = photo["url_sq"]
        end
      rescue => e
        RAILS_DEFAULT_LOGGER.error(response)
        RAILS_DEFAULT_LOGGER.error("[ERROR]: [API] Flikr")
        #RAILS_DEFAULT_LOGGER.error(e.inspect)
        #RAILS_DEFAULT_LOGGER.error(e.backtrace)
      end
      if response && response["photos"]
        return response["photos"]["photo"] 
      else
        return nil
      end
    end
    
    def sanitize_params(params)
      params["lon"] = params["lng"]
      allowed_fields = %w(user_id tags tag_mode text min_upload_date max_upload_date min_taken_date max_taken_date license sort privacy_filter bbox accuracy safe_search content_type machine_tags machine_tag_mode group_id contacts woe_id place_id media has_geo geo_context lat lon radius radius_units is_commons in_gallery is_getty extras per_page page)
      return params.reject{|k, v| not allowed_fields.include?(k)}
    end
    
  end
  

  

end
