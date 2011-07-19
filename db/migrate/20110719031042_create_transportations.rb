class CreateTransportations < ActiveRecord::Migration
  def self.up
    create_table :transportations do |t|
      t.integer :itinerary_id
      t.integer :mode
      t.datetime :start_time
      t.datetime :end_time
      t.text :extra_data
      t.timestamps
    end
  end

  def self.down
    drop_table :transportations
  end
end
