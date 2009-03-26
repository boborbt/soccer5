require 'test_helper'
require 'rubygems'
require 'mocha'


class InvitationTest < ActiveSupport::TestCase
  def setup
    @invitation = Invitation.new
  end
  
  # Replace this with your real tests.
  test "should allow accepting invitations" do
    match = mock()
    match.stubs(:datetime).returns(DateTime.now + 1)
    @invitation.stubs(:match).returns( match )
    
    @invitation.accept
    assert_equal 'accepted', @invitation.status
  end

  test "should allow rejecting invitations" do
      match = mock()
      match.stubs(:datetime).returns(DateTime.now + 1)
      @invitation.stubs(:match).returns( match )

      @invitation.reject
      assert_equal 'rejected', @invitation.status
    end
  
    test "should report pending if an invitation has not been accepted nor rejected" do
      assert_equal 'pending', @invitation.status
    end
  
    test "should not allow accepting the invitation if the match is in the past" do
      match = mock()
      match.stubs(:datetime).returns(DateTime.now - 1)
      @invitation.stubs(:match).returns( match )

      assert_raises InvitationError do
        @invitation.accept
      end
    end
  
    test "should not allow rejecting the invitation if the match is in the past" do
      match = mock()
      match.stubs(:datetime).returns(DateTime.now - 1)
      @invitation.stubs(:match).returns( match )

      assert_raises RuntimeError do
        @invitation.reject
      end
    end
  

end
