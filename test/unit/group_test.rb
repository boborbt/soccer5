require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "should return players to autoinvite" do
    players_to_autoinvite = groups(:one).players_to_autoinvite.map { |p| p.id }.sort 
    expected = [players(:p1).id, players(:p2).id, players(:player).id].sort

    assert_equal expected, players_to_autoinvite
  end
end
