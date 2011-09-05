class ItinerariesController < ApplicationController
  
  before_filter :validate_read_permission, :only => [:show]
  before_filter :validate_write_permission, :only => [:update]
  before_filter :validate_destroy_permission, :only => [:destroy]
  
  # GET /itineraries
  # GET /itineraries.xml
  # def index
  #   @itineraries = itinerary.all
  # 
  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.xml  { render :xml => @itineraries }
  #   end
  # end

  # GET /itineraries/1
  # /itineraries/:id/
  def show
    @itinerary = Itinerary.find(params[:id], :include => [:selected_events, :events, :selected_attractions, :attractions, :transportations, :selected_meals, :meals])
    @timeline = @itinerary.timeline
    #render :json => @timeline.to_json
  end
  
  # GET /itineraries/1/timeline
  def timeline
    @itinerary_items = Itinerary.find(params[:id], :include => [:events, :attractions, :meals, :transportations]).itinerary_items
    data = @itinerary_items.map do |item|
      {
        :id => item[:id], 
        :title => item.location.name,
        :start => item.start_time.to_i,
        :end => item.end_time.to_i,
        :className => item.item_type.downcase
      }
    end
    render :json => data
  end

  # # GET /itineraries/new
  # # GET /itineraries/new.xml
  # def new
  #   @itinerary = itinerary.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @itinerary }
  #   end
  # end
  # 
  # # GET /itineraries/1/edit
  # def edit
  #   @itinerary = itinerary.find(params[:id])
  # end

  # POST /itineraries
  def create
    @itinerary = Itinerary.new(params[:itinerary])
    @itinerary.owner_id = current_user[:id]

    if @itinerary.save
      render :json => {
        :success => true
      }
    else
      render :json => {
        :success => false
      }
    end
  end

  # PUT /itineraries/1
  def update
    @itinerary = Itinerary.find(params[:id])
    
    if @itinerary.update_attributes(params[:itinerary])
      render :json => {
        :success => true
      }
    else
      render :json => {
        :success => false
      }
    end
  end
  
  # POST /itineraries/fork
  def fork
    @original = Itinerary.find(params[:id])
    @itinerary = @original.fork(current_user)
    
  end

  # POST /itineraries/edit_name
  # def edit_name
  #   new_name = params[:update_value]
  #   itinerary = current_itinerary
  #   itinerary.name = new_name
  #   itinerary.save
  # 
  #   render :text => itinerary.name
  # end
  
  
  # POST /itineraries/1/event/create
  # Required: type (event, attraction, transportation)
  # def create_event
  #   case params[:type]
  #   when 
  #   
  # end
  
  # POST /itineraries/1/event/update/:event_id
  # Required: id, dayDelta, minuteDelta
  def drag_event_time
    item = ItineraryItem.find(params[:id])
    dayDelta = params[:dayDelta].to_i
    minuteDelta = params[:minuteDelta].to_i

    start_time = item.start_time + dayDelta.days + minuteDelta.minutes;
    end_time = item.end_time + dayDelta.days + minuteDelta.minutes;

    start = item.itinerary.start_time.to_date
    ending = item.itinerary.end_time.to_date

    if ((start_time.to_date <=> start) == -1) or ((end_time.to_date <=> ending) == 1)
      render :json => {:status => "1"}
    else
      item.update_attributes(:start_time => start_time, :end_time => end_time);
      render :json => {:status => "0"}
    end

  end

  # POST /itineraries/1/event/update/:event_id
  # Required: id, dayDelta, minuteDelta
  def resize_event_time 
    item = ItineraryItem.find(params[:id])
    dayDelta = params[:dayDelta].to_i
    minuteDelta = params[:minuteDelta].to_i

    end_time = item.end_time + dayDelta.days + minuteDelta.minutes;

    ending = item.itinerary.end_time.to_date

    if (end_time.to_date <=> ending) == 1
      render :json => {:status => "1"}
    else
      item.update_attributes(:end_time => end_time);
      render :json => {:status => "0"}
    end
  end


  # POST /itineraries/add_event
  # Required type (event, attraction, transportation), id, from, to
  def add_event
    id = params[:id].to_i
    from = Time.parse(params[:from])
    to = from + 1.day
    to = Time.parse(params[:to]) if params[:to]
    
    obj = nil
    if params[:type] == "event"
        obj = current_itinerary.add_event(id, from, to)  
    elsif params[:type] == "attraction"
        obj = current_itinerary.add_attraction(id, from, to)
    elsif params[:type] == "meal"
        obj = current_itinerary.add_meal(id, from, to)
    elsif params[:type] == "transportation"
        obj = current_itinerary.add_transportation(id, from, to)
    end

    render :json => {
        :status => 0,
        :obj => obj
    }
  end
  
  # DELETE /itineraries/1
  def destroy
    @itinerary = Itinerary.find(params[:id])
    @itinerary.destroy

    render :json => {
      :success => true
    }
  end

  def render_day
    date = params[:date].to_time
    @date = format_date(date)
    @events = current_itinerary.get_events(date)
    @attractions = current_itinerary.get_attractions(date)
    render :json => {
        :html => (render_to_string :partial => "home/day", :locals => {:events => @events, :attractions => @attractions})
    }
  end
  
  
  # GET /itineraries/1/finalize
  # Generate transportation
  def finalize
    @itinerary = Itinerary.find(params[:id], :include => [:selected_events, :events, :selected_attractions, :attractions, :transportations, :selected_meals, :meals])
    @itinerary.recommend_transportation!
    
    render :json => {
      :itinerary => @itinerary.timeline
    }.to_json
    
  end
  
  # GET/itineraries/1/show_day/yyyy-mm-dd
  def show_day
    @itinerary = Itinerary.find(params[:id])
    render :json => {:error => 'access denied'} unless current_user.can_read_itinerary?(@itinerary)
    
    @timeline = @itinerary.timeline(:include => [:events, :attractions, :transportations])
    date = "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    
    render :json => @timeline[date]
    
  end
  
  
  private
  def validate_write_permission
    current_user.can_update_itinerary?(Itinerary.find(params[:id]))
  end
  
  def validate_read_permission
    current_user.can_read_itinerary?(Itinerary.find(params[:id]))
  end
  
  def validate_destroy_permission
    current_user.can_destroy_itinerary?(Itinerary.find(params[:id]))
  end
  
end
