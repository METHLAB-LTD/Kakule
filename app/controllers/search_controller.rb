class SearchController < ApplicationController
  
  
  # POST /search/events
  # params => {"lat" : 25, "long" : -120, "radius" : 50, "query" : "ass", "start_time" : (new Date()).toLocaleString(), "end_time" : (new Date(2011,7,2)).toLocaleString()}
  def events
    #validate_time_range
    
    @events = Event.find(:all, 
      :conditions => ["(latitude between ? and ?) AND (longitude between ? and ?) 
        AND ((name LIKE ?) OR (description LIKE ?)) 
        AND (start_time < ? AND (end_time > ? OR end_time = ?))", 
        params[:lat].to_i - params[:radius].to_i, params[:lat].to_i + params[:radius].to_i, params[:long].to_i - params[:radius].to_i, params[:long].to_i + params[:radius].to_i,
        "%#{params[:query]}%",  "%#{params[:query]}%",
        Time.parse(params[:end_time]), Time.parse(params[:start_time]), nil
      ], :limit => 20)
    
    render :json => {
      :events => @events
    }
    
  end
  
  # POST /search/location
  def location
    data = SimpleGeo::Client.get_context(params[:lat], params[:long])
    render :json => {:location => data[:address][:properties][:city]}
  end
  
  
  
  
  
  
  
  
  
  
  private
  def validate_time_range
    if (Time.parse(params[:start_time]) > Time.parse(params[:end_time]) )
      render :json => {:error => "invalid time range"}
    end
  end
  
  
  
end
