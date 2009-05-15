class AddAutoFieldsToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :autocreate_matches, :boolean
    add_column :groups, :solicit1_ndays, :integer
    add_column :groups, :solicit2_ndays, :integer
  end

  def self.down
    remove_column :groups, :solicit2_ndays
    remove_column :groups, :solicit1_ndays
    remove_column :groups, :autocreate_maches
  end
end
