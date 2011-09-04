class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :author_id
      t.integer :itinerary_id
      t.string :title
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
