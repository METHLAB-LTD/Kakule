class AddFacebookToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_access_token, :string
    add_column :users, :timezone, :float
    add_column :users, :locale, :string
    add_column :users, :facebook_url, :string
    remove_column :users, :username
  end

  def self.down
    add_column :users, :username, :string
    remove_column :users, :facebook_url
    remove_column :users, :locale
    remove_column :users, :timezone
    remove_column :users, :facebook_access_token
  end
end
