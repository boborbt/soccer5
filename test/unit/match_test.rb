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
  
  test "should close a match when closing convocations" do
    match = matches(:match)
    assert_equal true, match.is_open?
    
    assert_nothing_raised do
      match.close_convocations!
    end
    
    match.reload
    assert_equal false, match.is_open?
  end
  
  test "should open a match without errors" do 
    match = matches(:match)
    match.status = Match::STATUSES[:closed]
    match.save!
    match.reload
    
    assert_equal false, match.is_open?
    
    match.reopen_convocations!
    match.reload
    assert_equal true, match.is_open?    
  end
  
  test "should find all open matches" do
    assert_equal 2, Match.all_open_matches.size
    
    Match.all_open_matches.each do |match|
      assert_equal true, match.is_open?
    end
  end

  test "should find all closed matches" do
    assert_equal 1, Match.all_closed_matches.size
    Match.all_closed_matches.each do |match|
      assert_equal true, match.is_closed?
    end    
  end

  test "should find all waiting matches" do
    assert_equal 1, Match.all_waiting_matches.size
    Match.all_waiting_matches.each do |match|
      assert_equal true, match.is_waiting?
    end    
  end
    
  test "clone_match_from_last_one should build a new match based on the current one, but one week later" do
    current_match = Match.current_match
    new_match = Match.clone_match_from_last_one
    
    assert_equal current_match.location, new_match.location
    assert_equal current_match.time, new_match.time
    assert_equal current_match.date + 7.days, new_match.date    
  end
  
  test "autoinvite_players! should send auto-invitations and change status to waiting" do
    assert_equal 2, Match.all_open_matches.size
    match = Match.all_open_matches[0]
    
    autoinvited_players = match.autoinvite_players!
    assert_equal Match::STATUSES[:waiting], match.status
    assert_equal players(:player), autoinvited_players[0]
  end
  
  test "solicit_players! should send solicitations to players and change status to solicit1" do
    assert_equal 2, Match.all_open_matches.size
    match = Match.all_open_matches[0]
    match.autoinvite_players!
    
    autoinvited_players = match.solicit_players!
    assert_equal Match::STATUSES[:solicit1], match.status
    assert_equal players(:player), autoinvited_players[0]
  end
  
end
