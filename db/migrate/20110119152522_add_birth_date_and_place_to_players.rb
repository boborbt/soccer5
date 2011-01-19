class AddBirthDateAndPlaceToPlayers < ActiveRecord::Migration
  def self.up
    add_column :players, :birth_date, :string
    add_column :players, :birth_place, :string
  end

  def self.down
    remove_column :players, :birth_place
    remove_column :players, :birth_date
  end
end
