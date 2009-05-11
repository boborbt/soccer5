class Group < ActiveRecord::Base
  has_many :groupings
  has_many :players, :throug => :groupings
end
