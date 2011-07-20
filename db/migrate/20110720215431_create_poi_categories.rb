class CreatePoiCategories < ActiveRecord::Migration
  def self.up
    create_table :poi_categories do |t|
      t.string  :name
      t.timestamps
    end
  end

  def self.down
    drop_table :poi_categories
  end
end
