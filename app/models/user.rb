class User < ActiveRecord::Base
  acts_as_authentic
  has_many :itineraries
  has_many :calendar_events, :through => :itineraries
  has_many :likes
end
