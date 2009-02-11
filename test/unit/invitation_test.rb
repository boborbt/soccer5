require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  def setup
    @invitation = Invitation.new
  end
  
  # Replace this with your real tests.
  test "should allow accepting invitations" do
    @invitation.accept
    assert_equal 'accepted', @invitation.status
  end

  test "should allow rejecting invitations" do
    @invitation.reject
    assert_equal 'rejected', @invitation.status
  end

  test "should report pending if an invitation has not been accepted nor rejected" do
    assert_equal 'pending', @invitation.status
  end

end
