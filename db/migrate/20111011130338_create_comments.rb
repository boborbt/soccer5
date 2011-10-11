class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.integer :player_id
      t.integer :match_id
      t.text :body, :limit => 1000

      t.timestamps
    end

    add_index :comments, :match_id
  end

  def self.down
    drop_table :comments
  end
end
