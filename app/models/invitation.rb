class Invitation < ActiveRecord::Base
  STATUSES = { :accepted => 'accepted', :rejected => 'rejected', :pending => 'pending' }

  belongs_to :match
  belongs_to :player  
  
  validates_uniqueness_of :acceptance_code, :refusal_code
  
  def Invitation.find_by_code( params )
    find_by_acceptance_code( params[:acceptance_code] ) || find_by_refusal_code( params[:refusal_code] )
  end
  
  
  def description
    [self.player.name, self.match.location.name, self.match.date.to_s, self.match.time.to_s].join('-')
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
    self[:status] != '' && self[:status] || STATUSES[:pending]
  end
  
  def accepted?
    self.status == STATUSES[:accepted]
  end

  def increment_sent_mails
    self.number_of_sent_mails += 1
    self.save!    
  end
  
  def solicit
    InvitationsMailer.deliver_solicitation(self)
    increment_sent_mails
  end
  
  def close_convocations
    InvitationsMailer.deliver_close_convocations(self)
    increment_sent_mails
  end  
end
