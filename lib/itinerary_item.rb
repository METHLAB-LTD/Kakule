module ItineraryItem  
  def is_confirmed?
    self[:is_confirmed]
  end
  
  def suggested_by
    User.find_by_id(self[:suggested_by])
  end
  
end