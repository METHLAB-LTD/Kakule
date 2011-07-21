class Attraction < ActiveRecord::Base
  has_many :likes, :as => :likable
  belongs_to :category, :class_name => "PoiCategory"
  
  @@default_radius = 10.0
  @@default_search_page = 20
  def self.find_by_custom_params(params)
    params[:radius] = @@default_radius if params[:radius].nil?
    params[:limit] = @@default_search_page if params[:limit].nil?

    lat = params[:lat].to_f
    lng = params[:long].to_f
    rad = params[:radius].to_f
    
    find(:all, 
      :conditions => ["(latitude between ? and ?) AND (longitude between ? and ?) AND (name LIKE ?)", 
        lat - rad, lat + rad, lng - rad, lng + rad, "%#{params[:query]}%",
      ], :limit => params[:limit].to_i)
  end
  
end
