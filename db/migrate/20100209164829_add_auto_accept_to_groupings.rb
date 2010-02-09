class AddAutoAcceptToGroupings < ActiveRecord::Migration
  def self.up
    add_column :groupings, :autoaccept, :boolean
  end

  def self.down
    remove_column :groupings, :autoaccept
  end
end
