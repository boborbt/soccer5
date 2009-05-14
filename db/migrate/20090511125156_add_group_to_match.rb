class AddGroupToMatch < ActiveRecord::Migration
  def self.up
    add_column :matches, :group_id, :integer

    begin
      Group.transaction do 
        Player.transaction do
          g = Group.create(:name => 'default')
          Match.transaction do 
            Match.find(:all).each do |match|
              match.group = g
              match.save!
            end
          
            Player.find(:all).each do |player|
              player.groups << g
              player.save!
            end
          end
        end
      end
    rescue
      self.down
      raise
    end
    
  end

  def self.down
    remove_column :matches, :group_id
    Group.find_by_name('default').destroy
  end
end
