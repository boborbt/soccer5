class AddAcceptedAtAndRejectedAtToInvitation < ActiveRecord::Migration
  def self.up
    add_column :invitations, :accepted_at, :datetime
    add_column :invitations, :rejected_at, :datetime
  end

  def self.down
    remove_column :invitations, :rejected_at
    remove_column :invitations, :accepted_at
  end
end
