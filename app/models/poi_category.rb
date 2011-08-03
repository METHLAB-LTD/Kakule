class PoiCategory < ActiveRecord::Base
  #has_many :attractions, :foreign_key => "category_id"
  has_many :attractions_categories, :class_name => "AttractionsCategories", :foreign_key => "category_id"
  has_many :attractions, :through => :attractions_categories
  validates_uniqueness_of :name
end
