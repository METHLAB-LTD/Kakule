class CreateSelectedMeals < ActiveRecord::Migration
  def self.up
    create_table :selected_meals do |t|
      t.integer :itinerary_id
      t.integer :attraction_id
      t.datetime :start_time
      t.datetime :end_time
      
      t.timestamps
    end
  end

  def self.down
    drop_table :selected_meals
  end
end
