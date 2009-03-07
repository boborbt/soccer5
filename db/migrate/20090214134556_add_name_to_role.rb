class AddNameToRole < ActiveRecord::Migration
  def self.up
    add_column :roles, :name, :string
    
    Role.create( :name => 'root' )
  end

  def self.down
    remove_column :roles, :name
  end
end
