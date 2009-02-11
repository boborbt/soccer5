class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.date :date
      t.time :time
      t.integer :location_id

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
