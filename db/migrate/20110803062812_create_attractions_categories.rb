class CreateAttractionsCategories < ActiveRecord::Migration
  def self.up
    create_table :attractions_categories do |t|
      t.integer :attraction_id
      t.integer :category_id
      t.timestamps
    end
  end

  def self.down
    drop_table :attractions_categories
  end
end
