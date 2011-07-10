class AddIsGuestToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_guest, :boolean, :default => false
    add_index :users, :is_guest, { :name => "users_is_guest_index" }
  end

  def self.down
    remove_column :users, :is_guest
    remove_index :users, :is_guest
  end
end
