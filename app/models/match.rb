class Match < ActiveRecord::Base
  belongs_to :location
  has_many :invitations
  has_many :players, :through => :invitations
  
  validates_presence_of :location
end
