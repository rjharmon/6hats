class AddSummaryToHat < ActiveRecord::Migration
  def self.up
    add_column :hats, :summary, :string
  end

  def self.down
    remove_column :hats, :summary
  end
end
