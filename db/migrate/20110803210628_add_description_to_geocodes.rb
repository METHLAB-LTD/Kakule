class AddDescriptionToGeocodes < ActiveRecord::Migration
  def self.up
    add_column :geocodes, :description, :text
  end

  def self.down
    remove_column :geocodes, :description
  end
end
