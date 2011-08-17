class Attraction < ActiveRecord::Base
  has_many :likes, :as => :likable
  
  has_many :attractions_categories, :class_name => "AttractionsCategories"
  has_many :categories, :through => :attractions_categories
  
  validates_uniqueness_of :yelp_id
  
  @@default_radius = 0.1
  @@default_search_page = 20
  @@ignore_categories = [6] #ignore airport
  def self.find_by_custom_params(params)
    params[:radius] = @@default_radius if params[:radius].nil?
    params[:limit] = @@default_search_page if params[:limit].nil?

    lat = params[:lat].to_f
    lng = params[:lng].to_f
    rad = params[:radius].to_f
    find(:all, 
      :conditions => ["(latitude between ? and ?) AND (longitude between ? and ?) AND (name LIKE ?) AND (NOT category_id IN (?))", 
        lat - rad, lat + rad, lng - rad, lng + rad, "%#{params[:query]}%", @@ignore_categories
      ], :limit => 20)
  end
  
  def self.find_with_yelp(params)
    
    categories = params[:category] || ["amusementparks"]
    
    RAILS_DEFAULT_LOGGER.info("[API] Yelp")
    client  = Yelp::Client.new
    request = Yelp::Review::Request::GeoPoint.new(
     :latitude => params[:lat],
     :longitude => params[:lng],
     :radius => 20,
     :term => params[:query],
     :category => categories,
     :yws_id => YELP_API_KEY)
    raw_data = client.search(request)
    return nil if raw_data["businesses"].nil?
    
    categories.map! { |cat| PoiCategory.find_or_create_by_name(cat.to_s) }
    
    return raw_data["businesses"].map do |business|
      attraction = Attraction.find_by_yelp_id(business["id"])
      unless attraction
        attraction = Attraction.create({
          :yelp_id => business["id"],
          :name => business["name"],
          :latitude => business["latitude"],
          :longitude => business["longitude"],
          :photo_url_small => business["photo_url_small"],
          :url => business["url"],
          :photo_url => business["photo_url"],
          :phone => business["phone"],
          :avg_rating => business["avg_rating"],
          :review_count => business["review_count"]
        })
        # TODO: Fix inefficiency
        business["categories"].each do |cat| 
          c = PoiCategory.find_or_create_by_name(cat["name"])
          attraction.attractions_categories.build({:category => c}).save
        end
      end
      attraction
    end
    
  end
end
