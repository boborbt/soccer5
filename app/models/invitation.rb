class Invitation < ActiveRecord::Base
  belongs_to :match
  belongs_to :player
  
  STATUSES = { :accepted => 'accepted', :rejected => 'rejected', :pending => 'pending' }
  
  validates_uniqueness_of :acceptance_code, :refusal_code
  
  def description
    [self.player.name, self.match.location.name, self.match.date.to_s, self.match.time.to_s].join('-')
  end
  
  def before_create
    self.acceptance_code = Digest::SHA1.hexdigest( 'acceptance' + player.name + match.id.to_s )
    self.refusal_code =  Digest::SHA1.hexdigest( 'rejection' + player.name + match.id.to_s )
  end

  
  def after_create
    InvitationsMailer.deliver_invitation(self)
    self.number_of_sent_mails += 1
    self.save!
  end
    
  def accept
    raise InvitationError.new("The match date is in the past! It is too late to accept the invitation.") unless match.datetime.future?
    
    self.status = STATUSES[:accepted]
    # stores the time of acceptance, but only if this datum did not already exist
    self.accepted_at = Time.now if self.accepted_at.nil?
  end
  
  def reject
    raise "The match date is in the past! It is too late to reject the invitation" unless match.datetime.future?    
    
    self.status = STATUSES[:rejected]
    # stores the time of rejection, but only if this datum did not already exist
    self.rejected_at = Time.now if self.rejected_at.nil?
  end
  
  def status
    self[:status] || STATUSES[:pending]
  end
  
  def solicit
    InvitationsMailer.deliver_solicitation(self)
    self.number_of_sent_mails += 1
    self.save!
  end  
end
