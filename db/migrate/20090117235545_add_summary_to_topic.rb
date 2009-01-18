class AddSummaryToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :summary, :text
  end

  def self.down
    remove_column :topics, :summary
  end
end
