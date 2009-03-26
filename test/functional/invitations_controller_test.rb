require 'test_helper'

class InvitationsControllerTest < ActionController::TestCase
  
  test "acceptance code should allow accepting inviations even if not logged in" do
    invitation = Invitation.find_by_acceptance_code('acceptance')
    
    # finding the correct match and changing its date to tomorrow (it is not
    # valid to accept invitations past the date of the match...)
    match = invitation.match
    match.date = Date.today + 1.days
    match.save!
    
    assert_difference 'match.number_of_coming_players' do 
      get 'accept_invitation', :id => 'acceptance'
      match.reload
    end
  end
  
  test "acceptance code should NOT allow accepting invitations whose match is in the past" do
      invitation = Invitation.find_by_acceptance_code('acceptance')
      match = invitation.match
      match.date = Date.today - 1.days
      match.save!
    
      assert_no_difference 'match.number_of_coming_players' do 
        match.reload
        get 'accept_invitation', :id => 'acceptance'
      end    
    end
    
  test "acceptance page should allow to specify a number of additional players" do
    invitation = Invitation.find_by_acceptance_code('acceptance')
    match = invitation.match
    match.date = Date.today + 1.days
    match.save!

    assert_difference 'match.number_of_coming_players', 3  do
      get 'accept_invitation', :id => 'acceptance'
      get 'set_additional_players', :acceptance_code => 'acceptance', :num_additional_players => 2
      match.reload      
    end
  end
  
end
