require 'test_helper'

class InvitationsMailerTest < ActionMailer::TestCase
  fixtures :invitations
  
  test "invitation" do
    @expected.subject = 'Sei stato nominato! (Partita del 2009-02-10 ore 19:00:00)'
    @expected.from    = 'boborbt@gmail.com'
    @expected.body    = read_fixture('invitation')
    @expected.date    = Time.now
    invitation = invitations(:one)
    
    @real = InvitationsMailer.create_invitation(invitations(:one))

    assert_equal @expected.subject, @real.subject
    assert_equal @expected.from, @expected.from
    assert_equal @expected.body, @expected.body
    assert_equal @expected.date, @expected.date    
  end

end
