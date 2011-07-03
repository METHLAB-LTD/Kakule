class Itinerary < ActiveRecord::Base
  belongs_to :owner, :class_name => :user
end
