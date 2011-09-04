class Itinerary < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :parent, :class_name => 'Itinerary'
  has_many :likes, :as => :likable
  
  has_many :itinerary_tags
  has_many :tags, :through => :itinerary_tags

  has_many :itinerary_items
  
  has_many :selected_attractions, :class_name => "ItineraryItem", :conditions => "itinerary_items.location_type = 'Attraction' AND itinerary_items.intent = 'Attraction'"
  has_many :attractions, :through => :selected_attractions
    
  has_many :selected_events, :class_name => "ItineraryItem", :conditions => "itinerary_items.location_type = 'Event'"
  has_many :events, :through => :selected_events
  
  has_many :selected_meals, :class_name => "ItineraryItem", :conditions => "itinerary_items.location_type = 'Attraction' AND itinerary_items.intent = 'Meal'"
  has_many :meals, :through => :selected_meals, :source => :attraction
    
  has_many :selected_transportations, :class_name => "ItineraryItem", :conditions => "itinerary_items.location_type = 'Transportation'"
  has_many :transportations, :through => :selected_transportations
  
  has_one :question
  
  validates_presence_of :owner_id
  
  def is_root?
    self.parent.nil?
  end
  
  @@permissions = {
    "Private" => 1,
    "Limited" => 2,
    "Public" => 3
  }

  @@defaults = {
    :name => "Your Itinerary",
    :permission_level => 1,
    :parent_id => nil
  }
  
  # Always preload. :include => [:selected_events, :events, :selected_attractions, :attractions, :transportations]
  def timeline(params={:include => [:events, :attractions, :meals, :transportations]})
    dataset = {}
    if params[:include]
        timeline_include_events(dataset) if params[:include].include?(:events)
        timeline_include_attractions(dataset) if params[:include].include?(:attractions)
        timeline_include_transportations(dataset) if params[:include].include?(:transportations)
        timeline_include_meals(dataset) if params[:include].include?(:meals)
    end
    
    dataset.each do |k, v|
      
    end
    
    return dataset
  end
  
  def recommend_transportation!
    dataset = self.timeline({:include => [:events, :attractions]})
    # need to sanitize: remove/disregard time blocks if n[:end_time] > n+1[:start_time]
    # assuming non-overlaps in time blocks...
    sorted_timeline = dataset.map{|k, v| v}.flatten.sort{|a, b| a[:start_time] <=> b[:start_time]}
    
    sorted_timeline.each_cons(2) do |from, to|
      duration = to[:start_time] - from[:end_time]
      recommendation = Transportation.recommend_transport(KakuleHelper.geo_distance(from[:lat], from[:lng], to[:lat], to[:lng]), duration)
      
      Transportation.create({
        :start_time => from[:end_time],
        :end_time => from[:end_time] + recommendation[:duration],
        :itinerary => self,
        :mode => recommendation[:mode]
      })
    end
    return self.transportations
  end

    
  
  # def fork(new_owner)
  #   forked = self.clone
  #   forked.parent_id = self[:id]
  #   forked.owner = new_owner
  #   forked.save
  #   self.selected_events.map{|s| s2=s.clone; s2.itinerary_id = forked[:id]; s2.save}
  #   self.selected_attractions.map{|a| a2=a.clone; a2.itinerary_id = forked[:id]; a2.save}
  #   self.transportations.map{|t| t2=t.clone; t2.itinerary_id = forked[:id]; t2.save}
  #   return forked
  # end
  

  def get_events(date) 
    #SelectedEvent.where(:itinerary_id => self.id).where(:start_time => (date)..(date + 1.days)).map {|s| s.event }
    self.events
  end 

  def get_attractions(date) 
    #SelectedAttraction.where(:itinerary_id => self.id).where(:start_time => (date)..(date + 1.days)).map {|s| s.attraction }
    self.attractions
  end 

  def add_event(id, from, to)
    ItineraryItem.add_event(self, Event.find(id), from, to)
  end

  def add_attraction(id, from, to)    
    ItineraryItem.add_attraction(self, Attraction.find(id), from, to)
  end

  def add_meal(id, from, to)
    ItineraryItem.add_meal(self, Attraction.find(id), from, to)
  end
  
  def add_transportation(id, from, to)
    
  end
  
  def self.permissions(str)
    @@permissions[str]
  end

  def self.create_itinerary(user)
    itinerary = Itinerary.new(@@defaults)
    itinerary.owner = user
    itinerary.save
    return itinerary
  end
  private
  
  def timeline_include_events(dataset)
    self.selected_events.each do |entry|      
      element = {
        :start_time => entry.start_time,
        :end_time => entry.end_time,
        :name => entry.location.name,
        :type => "event",
        :id => entry.location.id,
        :lat => entry.location.latitude,
        :lng => entry.location.longitude,
        :hashcode => entry.hash
      }
      
      break_time_into_days(dataset, element)
    end
    return dataset
  end
  
  def timeline_include_attractions(dataset)
    self.selected_attractions.each do |entry|
      element = {
        :start_time => entry.start_time,
        :end_time => entry.end_time,
        :name => entry.location.name,
        :type => "attraction",
        :id => entry.location.id,
        :lat => entry.location.latitude,
        :lng => entry.location.longitude,
        :hashcode => entry.hash
      }
      break_time_into_days(dataset, element)
    end
    return dataset
  end
  
  def timeline_include_transportations(dataset)
    self.transportations.each do |entry|
      element = {
        :start_time => entry.start_time,
        :end_time => entry.end_time,
        :name => entry.name,
        :type => "transportation",
        :id => entry.id,
        :hashcode => entry.hash
      }
      break_time_into_days(dataset, element)
    end
    return dataset
  end
  
  def timeline_include_meals(dataset)
    self.selected_meals.each do |entry|
      element = {
        :start_time => entry.start_time,
        :end_time => entry.end_time,
        :name => entry.location.name,
        :type => "meal",
        :id => entry.location.id,
        :lat => entry.location.latitude,
        :lng => entry.location.longitude,
        :hashcode => entry.hash
      }
      break_time_into_days(dataset, element)
    end
    return dataset
  end
  
  
  def break_time_into_days(dataset, element)
    days = []
    if (!element[:end_time].blank? && element[:start_time].to_date != element[:end_time].to_date) #more than one day
      (element[:start_time].to_date..element[:end_time].to_date).each do |day|
        dataset[day.strftime] ||= []
        e = element.clone
        if (day == element[:start_time].to_date)
          e[:end_time] = element[:start_time].end_of_day
        elsif (day == element[:end_time].to_date)
          e[:start_time] = element[:end_time].beginning_of_day
        else
          e[:start_time] = day.beginning_of_day
          e[:end_time] = day.end_of_day
        end
        dataset[day.strftime].push(e)
      end
    else
      dataset[element[:start_time].to_date.strftime] ||= []
      dataset[element[:start_time].to_date.strftime].push(element)
    end
    return dataset
  end

end
