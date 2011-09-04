class CreateItineraryItems < ActiveRecord::Migration
  def self.up
    create_table :itinerary_items do |t|
      t.integer :itinerary_id
      t.integer :location_id
      t.string :location_type
      t.string :intent
      t.datetime :start_time
      t.datetime :end_time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :itinerary_items
  end
end
