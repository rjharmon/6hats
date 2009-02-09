class AddStateToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :current_hat, :string, :default => 'Red'
    add_column :topics, :current_thought, :integer
  end

  def self.down
    remove_column :topics, :current_thought
    remove_column :topics, :current_hat
  end
end
