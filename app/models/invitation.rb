class Invitation < ActiveRecord::Base
  belongs_to :match
  belongs_to :player
  
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
  end
    
  def accept
    raise "Il match sì è già svolto. Non è più possibile accettare l'invito" unless match.datetime.future?
    
    self.status = 'accepted'
    # stores the time of acceptance, but only if this datum did not already exist
    self.accepted_at = Time.now if self.accepted_at.nil?
  end
  
  def reject
    raise "Il match sì è già svolto. Non è più possibile rifiutare l'invito" unless match.datetime.future?    
    
    self.status = 'rejected'
    # stores the time of rejection, but only if this datum did not already exist
    self.rejected_at = Time.now if self.rejected_at.nil?
  end
  
  def status
    self[:status] || 'pending'
  end  
end
