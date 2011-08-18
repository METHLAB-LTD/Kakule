class Geocode < ActiveRecord::Base
  belongs_to :timezone
  has_many :likes, :as => :likable
  
  def self.find_by_similar_name(str)
    arr = str.split(",").map{|a| a.strip}
    data = find(:all, :conditions => ["name LIKE ? AND (state LIKE ? OR country LIKE ?)", "#{arr[0]}%", "#{arr[1]}%", "#{arr[1]}%"], :order => :name, :limit => 10, :include => :likes)
    data.sort{|a, b| b.likes.length <=> a.likes.length}
  end
  
  def full_name
    "#{name}, #{!state.blank? ? state+", " : ""}#{country}"
  end

  def photos(num)
    return Flikr::Photos.new.search(
        {"lat" => latitude, 
         "lng" => longitude,
         "per_page" => num
        })
  end
  
  # TODO: Better WikiMarkup parser
  def fetch_and_store_description
    data = Wikipedia.find(self.name, :prop => "revisions" )
    self.update_attribute(:description, Wiky.process(data.content))
    return self
  end
end
