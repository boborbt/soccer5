class AddNumberOfSentMailsToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :number_of_sent_mails, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :invitations, :number_of_sent_mails
  end
end
