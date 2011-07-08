class Geocode < ActiveRecord::Base
  
  belongs_to :timezone
  
  def self.find_by_similar_name(str)
    find(:all, :conditions => ["name LIKE ?", "%#{str}%"], :order => :name)
  end
  
end
