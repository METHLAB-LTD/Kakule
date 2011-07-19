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
  
  def is_root?
    self.parent.nil?
  end
  
  @@permissions = {
    "Private" => 1,
    "Limited" => 2,
    "Public" => 3
  }

  @@defaults = {
    :name => "Default Title",
    :permission_level => 1,
    :parent_id => nil 
  }
  
  def timeline
    return {
      :selected_events => selected_events,
      :events => events,
      :selected_attractions => selected_attractions,
      :attractions => attractions,
      :transportations =>  transportations
    }
  end
  
  def self.permissions(str)
    @@permissions[str]
  end

  def self.create_itinerary(user)
    itinerary = Itinerary.new(@@defaults)
    itinerary.owner = user

    puts itinerary.save
    puts itinerary.errors
    return itinerary
  end

end
