class CreateRoleAttributions < ActiveRecord::Migration
  def self.up
    create_table :role_attributions do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :role_attributions
  end
end
