class AddAddressAndTelephoneToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :address, :string
    add_column :players, :phone, :string
  end

  def self.down
    remove_column :players, :phone
    remove_column :players, :address
  end
end
