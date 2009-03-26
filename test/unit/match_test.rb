require 'test_helper'

class MatchTest < ActiveSupport::TestCase
  fixtures :all
  
  test "should add 1 to the count of coming players if someone accept the invitation" do
    match = matches(:match)
    match.date = Date.today + 1.days
    match.save!
    
    assert_difference( 'match.number_of_coming_players' ) do
      match.invitations[0].accept
    end
  end
  
  test "should add 3 to the count of coming players if someone brings 3 additional players" do
    match = matches(:match)
    match.date = Date.today + 1.days
    match.save!

    assert_difference( 'match.number_of_coming_players', 3 ) do
      match.invitations[0].num_additional_players = 3
    end    
  end
  

end
