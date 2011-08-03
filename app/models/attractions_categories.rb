class AttractionsCategories < ActiveRecord::Base
  belongs_to :category, :class_name => "PoiCategory"
  belongs_to :attraction
end
