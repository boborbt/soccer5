class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :name
      t.integer :user_id
      t.string :email
      t.boolean :invite_always

      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
