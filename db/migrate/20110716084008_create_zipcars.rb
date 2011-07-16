class CreateZipcars < ActiveRecord::Migration
  def self.up
    create_table :zipcars do |t|
      t.string :location
      t.string :closest_airport
      
      t.timestamps
    end
  end

  def self.down
    drop_table :zipcars
  end
end
