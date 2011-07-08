class CreateTimezones < ActiveRecord::Migration
  def self.up
    create_table :timezones do |t|
      t.string :name
      t.string :gmt_offset
      t.string :dst_offset

      t.timestamps
    end
  end

  def self.down
    drop_table :timezones
  end
end
