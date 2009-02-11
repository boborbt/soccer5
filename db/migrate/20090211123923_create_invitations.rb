class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :match_id
      t.integer :player_id
      t.string :acceptance_code
      t.string :refusal_code

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
