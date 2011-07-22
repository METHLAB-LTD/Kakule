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
  def timeline
    dataset = {}
    
    self.selected_events.each do |entry|
      date = entry.start_time.date
      dataset[date] ||= []
      element = {
        :start_time => entry.start_time,
        :end_time => entry.end_time,
        :name => entry.event.name,
        :type => "event",
        :id => entry.event.id
      }
      dataset[date].push(element) 
    end
    
    self.selected_attractions.each do |entry|
      date = entry.start_time.date
      dataset[date] ||= []
      element = {
        :start_time => entry.start_time,
        :end_time => entry.end_time,
        :name => entry.attraction.name,
        :type => "attraction",
        :id => entry.attraction.id
      }
      dataset[date].push(element) 
    end
    
    self.transportations.each do |entry|
      date = entry.start_time.date
      dataset[date] ||= []
      element = {
        :start_time => entry.start_time,
        :end_time => entry.end_time,
        :name => entry.name,
        :type => "transportation",
        :id => entry.id
      }
      dataset[date].push(element) 
    end
    
    return dataset
    
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
  
  def self.permissions(str)
    @@permissions[str]
  end

  def self.create_itinerary(user)
    itinerary = Itinerary.new(@@defaults)
    itinerary.owner = user
    itinerary.save
  end
  
end
