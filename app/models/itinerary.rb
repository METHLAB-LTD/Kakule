class Itinerary < ActiveRecord::Base
  belongs_to :owner, :class_name => :user
  has_many :likes, :as => :likable
  
end
