class AddStartTimeAndEndTimeToItinerary < ActiveRecord::Migration
  def self.up
    add_column :itineraries, :start_time, :datetime
    add_column :itineraries, :end_time, :datetime
  end

  def self.down
    remove_column :itineraries, :end_time
    remove_column :itineraries, :start_time
  end
end
