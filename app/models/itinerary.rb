class Itinerary < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User'
  belongs_to :parent, :class_name => 'Itinerary'
  has_many :likes, :as => :likable
  
  @@permissions = {
    "Private" => 1,
    "Limited" => 2,
    "Public" => 3
  }
  
  def self.permissions(str)
    @@permissions(str)
  end
  
  def is_root?
    self.parent.nil?
  end
  
  

  
end
