class PoiCategory < ActiveRecord::Base
  has_many :attractions, :foreign_key => "category_id"
end
