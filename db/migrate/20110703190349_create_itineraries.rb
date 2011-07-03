class CreateItineraries < ActiveRecord::Migration
  def self.up
    create_table :itineraries do |t|
      t.string :name
      t.references :owner

      t.timestamps
    end
  end

  def self.down
    drop_table :itineraries
  end
end
