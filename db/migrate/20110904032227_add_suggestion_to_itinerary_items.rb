class AddSuggestionToItineraryItems < ActiveRecord::Migration
  def self.up
    add_column :selected_attractions, :is_confirmed, :boolean, :default => false
    add_column :selected_attractions, :suggested_by, :integer
    add_column :selected_events, :is_confirmed, :boolean, :default => false
    add_column :selected_events, :suggested_by, :integer
    add_column :selected_meals, :is_confirmed, :boolean, :default => false
    add_column :selected_meals, :suggested_by, :integer
    add_column :transportations, :is_confirmed, :boolean, :default => false
    add_column :transportations, :suggested_by, :integer
  end

  def self.down
    remove_column :selected_attractions, :is_confirmed
    remove_column :selected_attractions, :suggested_by
    remove_column :selected_events, :is_confirmed
    remove_column :selected_events, :suggested_by
    remove_column :selected_meals, :is_confirmed
    remove_column :selected_meals, :suggested_by
    remove_column :transportations, :is_confirmed
    remove_column :transportations, :suggested_by
  end
end
