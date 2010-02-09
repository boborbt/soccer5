class Group < ActiveRecord::Base
  has_many :groupings, :dependent => :destroy
  has_many :players, :through => :groupings
  has_many :matches, :dependent => :destroy
  
  def players_to_autoinvite
    groupings.find_all_by_autoinvite(true).map { |g| g.player }
  end
    
  def players_not_in_group
    (Player.find(:all) - self.players)
  end
end
