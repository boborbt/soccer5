class Role < ActiveRecord::Base
  has_many :role_attributions
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
    begin
      Role.find_by_name(name).id
    rescue
      logger.warn( "Error while retrieving role object: could not find #{name} role." +
         " Reason of the error: [#{$!}]. Returning false" )
      false
    end
  end
end
