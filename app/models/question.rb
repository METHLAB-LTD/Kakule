class Question < ActiveRecord::Base
  belongs_to :itinerary
  belongs_to :author, :class_name => 'User'
end
