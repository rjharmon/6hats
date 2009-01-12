class CreateThoughts < ActiveRecord::Migration
  def self.up
    create_table :thoughts do |t|
      t.integer :topic_id
      t.string :summary
      t.text :detail
      t.integer :hat_id

      t.timestamps
    end
  end

  def self.down
    drop_table :thoughts
  end
end
