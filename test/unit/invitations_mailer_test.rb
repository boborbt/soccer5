require 'test_helper'

class InvitationsMailerTest < ActionMailer::TestCase
  fixtures :invitations
  
  test "invitation" do
    @expected.subject = 'Sei stato nominato! (Partita del 2009-02-10 ore 19:00:00)'
    @expected.from    = 'boborbt@gmail.com'
    @expected.body    = read_fixture('invitation')
    @expected.date    = Time.now
    invitation = invitations(:one)

    assert_equal @expected.encoded, InvitationsMailer.create_invitation(invitations(:one)).encoded
  end

end
