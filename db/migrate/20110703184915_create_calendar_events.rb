class CreateCalendarEvents < ActiveRecord::Migration
  def self.up
    create_table :calendar_events do |t|
      t.string :name
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :all_day, :default => false
      t.event_type :string
      t.references :itinerary
      
      t.timestamps
    end
  end

  def self.down
    drop_table :calendar_events
  end
end
