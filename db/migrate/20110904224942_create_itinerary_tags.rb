class CreateItineraryTags < ActiveRecord::Migration
  def self.up
    create_table :itinerary_tags do |t|
      t.integer :itinerary_id
      t.integer :tag_id
      t.timestamps
    end
  end

  def self.down
    drop_table :itinerary_tags
  end
end
