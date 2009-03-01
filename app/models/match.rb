class Match < ActiveRecord::Base
  belongs_to :location
  has_many :invitations
  has_many :players, :through => :invitations
  
  validates_presence_of :location
  
  # def datetime
  #   DateTime.new(date.year, date.month, date.day, time.hours, time.minutes)
  # end
  
  def autoinvite_players
    Player.find_all_by_invite_always(true).each do |player|
      self.players << player
    end
  end
  
  def accepted_invitations
    invitations.find_all_by_status('accepted', :order => 'accepted_at ASC')
  end
  
  def rejected_invitations
    invitations.find_all_by_status('rejected', :order => 'rejected_at ASC')
  end
  
  def unresponded_invitations 
    invitations.find_all_by_status(nil)
  end
  
  def uninvited_players 
    Player.find(:all) - players
  end
  
  def max_players
    10
  end
end
