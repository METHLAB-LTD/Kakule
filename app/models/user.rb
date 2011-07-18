class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.merge_validates_format_of_login_field_options :unless => :can_bypass_validation?
    config.merge_validates_length_of_login_field_options :unless => :can_bypass_validation?
    config.merge_validates_length_of_password_field_options :unless => :can_bypass_validation?
    config.merge_validates_format_of_email_field_options :unless => :can_bypass_validation?
  end

  has_many :itineraries, :foreign_key => "owner_id"
  has_many :calendar_events, :through => :itineraries
  has_many :likes
   

  
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
    UserSession.create(guest, true)
  end
  
  
  def name
    "#{first_name} #{last_name}"
  end
  
end
