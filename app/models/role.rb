class Role < ActiveRecord::Base
  has_many :users, :through => :role_attributions
  has_one :player
end
