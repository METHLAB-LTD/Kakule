class Geocode < ActiveRecord::Base
  belongs_to :timezone
  has_many :likes, :as => :likable
  
  def self.find_by_similar_name(str)
    arr = str.split(",").map{|a| a.strip}
    find(:all, :conditions => ["name LIKE ? AND (state LIKE ? OR country LIKE ?)", "%#{arr[0]}%", "%#{arr[1]}%", "%#{arr[1]}%"], :order => :name, :limit => 10)
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
end
