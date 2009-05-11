class Player < ActiveRecord::Base
  belongs_to :user
  has_many :invitations
  has_many :matches, :through => :invitations
  has_many :groupings
  has_many :groups, :through => :groupings
  
  validates_uniqueness_of :name, :case_sensitive => false
  
  def email
    p_email = self[:email].blank? ? nil : self[:email]
    p_email || (self.user && self.user.email)
  end
end
