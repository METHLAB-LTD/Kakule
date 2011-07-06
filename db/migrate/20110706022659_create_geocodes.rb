class CreateGeocodes < ActiveRecord::Migration
  def self.up
    create_table :geocodes do |t|

      t.string :name
      t.float :latitude
      t.float :longitude
      
      t.timestamps
    end
  end

  def self.down
    drop_table :geocodes
  end
end