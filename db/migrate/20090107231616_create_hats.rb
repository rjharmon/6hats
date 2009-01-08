class CreateHats < ActiveRecord::Migration
  def self.up
    create_table :hats do |t|
      t.string :color
      t.text :description
      t.text :more_info

      t.timestamps
    end
  end

  def self.down
    drop_table :hats
  end
end
