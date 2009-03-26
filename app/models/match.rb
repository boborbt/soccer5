class Match < ActiveRecord::Base
  belongs_to :location
  has_many :invitations
  has_many :players, :through => :invitations
  
  validates_presence_of :location
  
  def Match.current_match
    Match.find(:all, :order =>'abs(date -now()) ASC', :limit => 1)[0]
  end
  
  def description
    "Match on %s at %s" % [self.date.to_s, self.location.name]
  end
  
  def number_of_coming_players
    self.invitations.inject(0) do |s,i|
      s + i.num_additional_players + ( i.status == Invitation::STATUSES[:accepted] ? 1 : 0 )
    end
  end
  
  def datetime
    DateTime.new(date.year, date.month, date.day, time.hour, time.min)
  end
  
  def autoinvite_players!
    Player.find_all_by_invite_always(true).each do |player|
      self.players << player
    end
    
    self.save!
  end
  
  def solicit_players
    self.invitations.each do |invitation|
      invitation.solicit if invitation.status == Invitation::STATUSES[:pending]
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
  
  def last_changed_invitation
    invitations.max { |inv1, inv2| inv1.updated_at <=> inv2.updated_at }
  end
  
end
