require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  fixtures :players
  
  def setup
    @user = User.new
    @player = players(:player)
  end
  
  
  # Replace this with your real tests.
  test "should return user email if the player email is empty" do
    @player.email = ""
    @user.expects(:email).returns('player@mockfactory.com')
    @player.user = @user
    assert_equal 'player@mockfactory.com', @player.email
  end
  
  test "should return player email fi the player email is not empty" do
    @player.email = "player@testingfactory.com"
    @user.stubs(:email).returns('player@mockfactory.com')
    @player.user = @user
    assert_equal 'player@testingfactory.com', @player.email
  end
end
