class AddUserRole < ActiveRecord::Migration
  def self.up
    Role.create(:name => 'user')
  end

  def self.down
  end
end
