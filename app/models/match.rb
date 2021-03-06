class Match < ActiveRecord::Base
  belongs_to  :location
  has_many    :invitations, :dependent => :destroy
  has_many    :unrejected_invitations, :class_name => 'Invitation',
                :conditions => [ 'status IS NULL OR status != ?', Invitation::STATUSES[:rejected] ]

  has_many    :players, :through => :invitations
  has_many    :interested_players, :through => :unrejected_invitations, :source => :player
  has_many    :comments

  belongs_to  :group
  
  validates_presence_of :location
  validates_presence_of :group
  
  STATUSES = { 
                :open => 'open', # match just opened, no invitation sent
                :waiting => 'waiting', # match open, invitations sent, waiting for replies
                :solicit1 => 'solicit1', # match open, invitations sent, 1 solicitation mail sent
                :solicit2 => 'solicit2', # match open, invitations sent, 2 solicitation mails sent
                :closed => 'closed' # match closed, invitations should not be accepted any more (they will, but it should not be the norm)
             }
             
  # --------------------------------------------------------------------------------
  # Creating matches 
  # --------------------------------------------------------------------------------
  def Match.clone_match_from_last_one(group)
    current_match = Match.current_match(group) || Match.last_match(group)
    raise "No previous match found!" if current_match.nil?
    
    match = Match.new
    match.date = current_match.date + 1.week
    match.time = current_match.time
    match.location = current_match.location
    match.group = group
    
    match
  end
  
  # --------------------------------------------------------------------------------
  # Retrieving matches              
  # --------------------------------------------------------------------------------

  def Match.current_match(group)
    Match.find(:all, :conditions => %Q{status<>'#{STATUSES[:closed]}'}, :order => 'abs(date-now()) ASC').find do |m|
      m.group == group
    end
  end
  
  def Match.last_match(group)
    group.matches.find(:all, :order => 'abs(date-now()) ASC')[0]
  end
    
  def Match.all_open_matches
    Match.find(:all, :conditions => %Q{status='#{STATUSES[:open]}'}, :order => 'abs(date-now()) ASC')
  end
  
  def Match.all_closed_matches
    Match.find(:all, :conditions => %Q{status='#{STATUSES[:closed]}'}, :order =>'abs(date -now()) ASC')
  end
  
  def Match.all_matches_not_closed
    Match.find(:all, :conditions => %Q{status<>'#{STATUSES[:closed]}'}, :order => 'abs(date-now()) ASC')
  end
  
  def Match.all_waiting_matches
    Match.find(:all, :conditions => ['status=:waiting OR status=:solicit1 OR status=:solicit2',
                                      {:waiting => STATUSES[:waiting], 
                                       :solicit1 => STATUSES[:solicit1], 
                                       :solicit2 => STATUSES[:solicit2]}],
                     :order => 'abs(date-now()) ASC')
  end
    
  # --------------------------------------------------------------------------------
  # Querying 
  # --------------------------------------------------------------------------------
  
  def description
    "Match on %s at %s" % [self.date.to_s, self.location.name]
  end
  
  
   def max_players
     10
   end

   def last_changed_invitation
     invitations.max { |inv1, inv2| inv1.updated_at <=> inv2.updated_at }
   end  
    
  def invitations_with_additional_players
    self.invitations.find_all { |i| i.num_additional_players > 0 }
  end
  
  
  def number_of_coming_players
    self.invitations.inject(0) do |s,i|
      s + i.num_additional_players + ( i.status == Invitation::STATUSES[:accepted] ? 1 : 0 )
    end
  end
  
  def datetime
    DateTime.new(date.year, date.month, date.day, time.hour, time.min)
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
    self.group.players - players
  end
  
  # handles is_xxx? methods (meant to return status values: e.g., is_waiting?, is_closed?, etc.)
  def method_missing(method_id, *arguments)    
    match = method_id.to_s.match(/is_(.*)\?/)
    if match && STATUSES.keys.map { |k| k.to_s }.include?(match[1])
        return self.status == STATUSES[match[1].to_sym]
    end
    
    super
  end
  
  
  # --------------------------------------------------------------------------------
  # Actions 
  # --------------------------------------------------------------------------------

  def add_comment(player, body)
    comment = Comment.new(:player => player, :body => body, :match_id => self.id)
    self.comments << comment
    self.save!

    CommunicationsMailer.deliver_comment(comment)
  end
  
  def autoinvite_players!
    players = self.group.players_to_autoinvite
    players.each do |player|
      # the inclusion in self.players creates the invitation causing the mail
      # sending (see class InvitationObserver, methods before and after create).
      self.players << player
    end
        
    self.status = Match::STATUSES[:waiting]    
    self.save!
    
    players
  end
  
  def solicit_players!
    solicited_players = []
    
    self.invitations.each do |invitation|
      if invitation.status == Invitation::STATUSES[:pending]
        invitation.solicit 
        solicited_players << invitation.player
      end
    end
    
    self.status = case self.status
                  when STATUSES[:waiting] then STATUSES[:solicit1]
                  when STATUSES[:solicit1] then STATUSES[:solicit2]
                  when STATUSES[:solicit2] then STATUSES[:solicit2]
                  when STATUSES[:closed] then STATUSES[:closed]
                  end
    self.save!
    
    solicited_players
  end
  
  def close_convocations!
    self.status = Match::STATUSES[:closed]
    self.save!
    
    self.invitations.each do |invitation|
      invitation.close_convocations if [Invitation::STATUSES[:pending], Invitation::STATUSES[:accepted]].include?(invitation.status)
    end
  end
  
  def reopen_convocations!
    self.status = Match::STATUSES[:open]
    self.save!
  end
      
end
