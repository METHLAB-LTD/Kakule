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
  # /itineraries/:id/:year/:month
  def show
    @timeline = Itinerary.find(params[:id], :include => [:selected_events, :events, :selected_attractions, :attractions, :transportations]).timeline
    
    
    render :json => @itinerary.timeline.to_json
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
  def edit_name
    new_name = params[:update_value]
    itinerary = current_itinerary
    itinerary.name = new_name
    itinerary.save

    render :text => itinerary.name
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
    @date = format_date(params[:date].to_time)
    render :json => {
        :html => (render_to_string :partial => "home/addpanel")
    }
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
