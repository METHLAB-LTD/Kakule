class Attraction < ActiveRecord::Base
  has_many :likes, :as => :likable
  belongs_to :category, :class_name => "PoiCategory"
  
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
  
end
