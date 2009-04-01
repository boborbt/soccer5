class AddOpenToMatch < ActiveRecord::Migration
  def self.up
    add_column :matches, :status, :string, :null => false, :default => 'open'
    
    Match.transaction do
      begin
        current = Match.find(:all, :order => 'abs(date -now()) ASC', :limit => 1)[0]
        current.status = 'open'
        current.save!
        
        Match.find(:all).each do |match|
          unless match == current
            match.status = 'closed'
            match.save!
          end
        end
      rescue
        self.down
        raise
      end
    end
  end

  def self.down
    remove_column :matches, :status
  end
end
