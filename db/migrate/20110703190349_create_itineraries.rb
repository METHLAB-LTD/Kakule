class CreateItineraries < ActiveRecord::Migration
  def self.up
    create_table :itineraries do |t|
      t.string :name
      t.integer :parent_id
      
      t.text :stringified_data
      t.integer :permission_level

      t.timestamps
    end
  end

  def self.down
    drop_table :itineraries
  end
end
