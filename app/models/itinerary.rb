class Itinerary < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :parent, :class_name => 'Itinerary'
  has_many :likes, :as => :likable
  
  has_many :selected_attractions
  has_many :attractions, :through => :selected_attractions
  has_many :selected_events
  has_many :events, :through => :selected_events
  has_many :transportations

  validates_presence_of :owner_id
  
  #validates_presence_of :parent_id
  
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
  def timeline(params={})
    dataset = {}
    if params[:include]
        timeline_include_events(dataset) if params[:include].include?(:events)
        timeline_include_attractions(dataset) if params[:include].include?(:attractions)
        timeline_include_transportations(dataset) if params[:include].include?(:transportations)
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

    
  
  def fork(new_owner)
    forked = self.clone
    forked.parent_id = self[:id]
    forked.owner = new_owner
    forked.save
    self.selected_events.map{|s| s2=s.clone; s2.itinerary_id = forked[:id]; s2.save}
    self.selected_attractions.map{|a| a2=a.clone; a2.itinerary_id = forked[:id]; a2.save}
    self.transportations.map{|t| t2=t.clone; t2.itinerary_id = forked[:id]; t2.save}
    return forked
  end
  
  #github style name
  def full_name
    "#{self.owner.name} :: #{self.name}"
  end

  def add_event(id, from, to)
    sel_event = SelectedEvent.create({
      :event_id => id,
      :itinerary_id => self.id,
      :start_time => from,
      :end_time => to
    })
    
    return Event.find(id)
  end

  def add_attraction(id, from, to)    
    sel_attr = SelectedAttraction.create({
      :attraction_id => id,
      :itinerary_id => self.id,
      :start_time => from,
      :end_time => to
    })
    
    return Attraction.find(id)
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
  end
  
  private
  
  def timeline_include_events(dataset)
    self.selected_events.each do |entry|      
      element = {
        :start_time => entry.start_time,
        :end_time => entry.end_time,
        :name => entry.event.name,
        :type => "event",
        :id => entry.event.id,
        :lat => entry.event.latitude,
        :lng => entry.event.longitude,
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
        :name => entry.attraction.name,
        :type => "attraction",
        :id => entry.attraction.id,
        :lat => entry.attraction.latitude,
        :lng => entry.attraction.longitude,
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
