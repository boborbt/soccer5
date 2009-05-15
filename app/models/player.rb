class Player < ActiveRecord::Base
  belongs_to :user
  has_many :invitations, :dependent => :destroy
  has_many :matches, :through => :invitations
  has_many :groupings, :dependent => :destroy
  has_many :groups, :through => :groupings
  
  validates_uniqueness_of :name, :case_sensitive => false
  
  def email
    p_email = self[:email].blank? ? nil : self[:email]
    p_email || (self.user && self.user.email)
  end
  
  def groups_with_autoinvitations
    groupings.find_all_by_player_id_and_autoinvite(self, true).map { |g| g.group }.compact
  end
end
