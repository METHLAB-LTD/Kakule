class AddDescriptionToGeocodes < ActiveRecord::Migration
  def self.up
    add_column :geocodes, :description, :text
    add_index :geocodes, :name, { :name => "geocodes_name_index" }
    add_index :geocodes, :state, { :name => "geocodes_state_index" }
    add_index :geocodes, :country, { :name => "geocodes_country_index" }
  end

  def self.down
    remove_column :geocodes, :description
    remove_index :geocodes, :name => "geocodes_name_index"
    remove_index :geocodes, :name => "geocodes_state_index"
    remove_index :geocodes, :name => "geocodes_country_index"
  end
end
