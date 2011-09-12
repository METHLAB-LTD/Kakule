class Tag < ActiveRecord::Base
  has_many :itinerary_tags
  has_many :itineraries, :through => :itinerary_tags
  
  
  def questions
    #TODO: Optimize
    self.itineraries.map{|i| i.question}
  end
  
end
