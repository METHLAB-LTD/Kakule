class CreateAttractions < ActiveRecord::Migration
  def self.up
    create_table :attractions do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :yelp_id
      t.string :photo_url_small
      t.string :url
      t.string :photo_url
      t.string :phone
      t.float :avg_rating
      t.integer :review_count
      
      t.timestamps
    end
    add_index :attractions, :yelp_id, { :name => "attractions_yelp_id_index" }
  end

  def self.down
    drop_table :attractions
  end
end
