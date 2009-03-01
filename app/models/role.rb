class Role < ActiveRecord::Base
  has_many :users, :through => :role_attributions
  has_one :player
  
  # --------------------------------------------------------------------------------
  # METHOD MISSING 
  # --------------------------------------------------------------------------------
  
  def inspect
    self.name
  end
  
  def to_s
    self.name
  end
  
  def Role.[](name)
    Role.find_by_name(name)
  end
end
