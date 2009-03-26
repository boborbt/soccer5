class AddNumAdditionalPlayersToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :num_additional_players, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :invitations, :num_additional_players
  end
end
