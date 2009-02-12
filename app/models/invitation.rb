class Invitation < ActiveRecord::Base
  belongs_to :match
  belongs_to :player
  
  def before_create
    self.acceptance_code = Digest::SHA1.hexdigest( 'acceptance' + player.name + match.id.to_s )
    self.refusal_code =  Digest::SHA1.hexdigest( 'rejection' + player.name + match.id.to_s )
  end
  
  def accept
    self.status = 'accepted'
  end
  
  def reject
    self.status = 'rejected'
  end
  
  def status
    self[:status] || 'pending'
  end
end
