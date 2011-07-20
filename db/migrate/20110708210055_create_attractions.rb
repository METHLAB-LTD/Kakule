class CreateAttractions < ActiveRecord::Migration
  def self.up
    create_table :attractions do |t|
      t.string :name
      t.integer :category_id
      t.float :latitude
      t.float :longitude
      

      t.timestamps
    end
  end

  def self.down
    drop_table :attractions
  end
end
