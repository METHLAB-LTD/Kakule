class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :eventful_id
      t.string :name
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :venue
      t.string :street
      t.string :city
      t.string :state
      t.string :postal
      t.string :country
      t.float :latitude
      t.float :longitude
      t.string :picture_url

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
