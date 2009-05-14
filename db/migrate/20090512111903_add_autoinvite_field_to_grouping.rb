class AddAutoinviteFieldToGrouping < ActiveRecord::Migration
  def self.up
    add_column :groupings, :autoinvite, :boolean
    
    begin
      Grouping.transaction do
        Player.find(:all).each do |player|
          player.groupings[0].autoinvite = player.invite_always
        end
      end
      
      remove_column :players, :invite_always
    rescue 
      self.down
      raise
    end
    
    
  end

  def self.down
    remove_column :groupings, :autoinvite
  end
end
