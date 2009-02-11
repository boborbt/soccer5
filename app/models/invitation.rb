class Invitation < ActiveRecord::Base
  belongs_to :match
  belongs_to :player
  
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
