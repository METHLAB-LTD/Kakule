class CreateGeocodes < ActiveRecord::Migration
  def self.up
    create_table :geocodes do |t|

      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :state
      t.string :country
      t.integer :population
      t.integer :gtopo30
      t.integer :timezone_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :geocodes
  end
end