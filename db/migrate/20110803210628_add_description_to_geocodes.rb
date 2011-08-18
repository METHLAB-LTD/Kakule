class AddDescriptionToGeocodes < ActiveRecord::Migration
  def self.up
    add_column :geocodes, :description, :text
    add_index :geocodes, :name, { :name => "geocodes_name_index" }
  end

  def self.down
    remove_column :geocodes, :description
    remove_index :geocodes, "geocodes_name_index"
  end
end
