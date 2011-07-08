class Attraction < ActiveRecord::Base
  has_many :likes, :as => :likable
  
end
