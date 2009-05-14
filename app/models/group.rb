class Group < ActiveRecord::Base
  has_many :groupings
  has_many :players, :through => :groupings
  has_many :matches
  
  def players_to_autoinvite
    groupings.find_all_by_autoinvite(true).map { |g| g.player }
  end
end
