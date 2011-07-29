class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.merge_validates_format_of_login_field_options :unless => :is_guest?
    config.merge_validates_length_of_login_field_options :unless => :is_guest?
    config.merge_validates_length_of_password_field_options :unless => :is_guest?
    config.merge_validates_format_of_email_field_options :unless => :is_guest?
  end

  has_many :itineraries, :foreign_key => 'owner_id'
  has_many :calendar_events, :through => :itineraries
  has_many :likes
  
  has_many :friends, :through => :friendships
  has_many :friendships, :dependent => :destroy, :conditions => {:confirmed => true}
  
  has_many :pending_friends, :through => :pending_friendships, :source => :friend
  has_many :pending_friendships, :dependent => :destroy, :conditions => {:confirmed => false}, :class_name => "Friendship"
   
  def can_bypass_validation?
    is_guest? || registered_using_facebook?
  end
  
  def registered_using_facebook?
    !facebook_access_token.blank?
  end
  
  def is_guest? 
    is_guest
  end

  def can_read_itinerary?(itinerary)
    itinerary.owner == self || itinerary.permission_level >= Itinerary.permissions("Limited")
  end
  
  def can_update_itinerary?(itinerary)
    itinerary.owner == self
  end
  
  def can_destroy_itinerary(itinerary)
    itinerary.owner == self
  end
  
  def self.create_guest
    guest = User.create(:is_guest => true)
    itinerary = Itinerary.create_itinerary(guest)
    session = UserSession.create(guest, true)
    return guest
  end
  
  def name
    is_guest? ? "Guest-#{id}" : "#{first_name} #{last_name}"
  end
  
end
