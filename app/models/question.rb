class Question < ActiveRecord::Base
  belongs_to :itinerary
  belongs_to :author, :class_name => 'User'
  
  validates_presence_of :itinerary_id, :author_id
  
end
