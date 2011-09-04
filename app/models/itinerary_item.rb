class ItineraryItem < ActiveRecord::Base
  belongs_to :itinerary
  belongs_to :location, :polymorphic => true
  
  # possible intents: Attraction, Meal
  belongs_to :attraction, :class_name => "Attraction", :foreign_key => "location_id"
  belongs_to :event, :class_name => "Event", :foreign_key => "location_id"
  belongs_to :transportation, :class_name => "Transportation", :foreign_key => "location_id"
  
  
  validates_presence_of :start_time, :end_time
  
  
                    
  # module ItineraryItem  
  #   def is_confirmed?
  #     self[:is_confirmed]
  #   end
  #   
  #   def suggested_by
  #     User.find_by_id(self[:suggested_by])
  #   end
  #   
  # end
  
  def self.add_event(itinerary, event, from, to)
    create({
      :itinerary_id => itinerary.id,
      :location_id => event.id,
      :location_type => "Event",
      :start_time => from,
      :end_time => to
    })
    return event
  end
  def self.add_attraction(itinerary, attraction, from, to)
    create({
      :itinerary_id => itinerary.id,
      :location_id => attraction.id,
      :location_type => "Attraction",
      :intent => "Attraction"
      :start_time => from,
      :end_time => to
    })
    return attraction
  end
  def self.add_meal(itinerary, meal, from, to)
    create({
      :itinerary_id => itinerary.id,
      :location_id => meal.id,
      :location_type => "Attraction",
      :intent => "Meal"
      :start_time => from,
      :end_time => to
    })
    return meal
  end
end
