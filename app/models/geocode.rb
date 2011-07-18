class Geocode < ActiveRecord::Base
  belongs_to :timezone
  has_many :likes, :as => :likable
  
  def self.find_by_similar_name(str)
    find(:all, :conditions => ["name LIKE ?", "%#{str}%"], :order => :name, :limit => 10)
  end
  
  def full_name
    "#{name}, #{!state.blank? ? state+", " : ""}#{country}"
  end
end
