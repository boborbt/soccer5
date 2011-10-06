require 'test_helper'

class InvitationObserverTest < ActiveSupport::TestCase
	def setup
		match = Match.new
		i0 = Invitation.new
		i0.player = Player.new(:name => 'obob')
		i0.match = match
		i0.save!

		@i = Invitation.new
		@i.player = Player.new(:name => 'bobo')
		@i.match = match
		@i.save!

		match.location = Location.new
		match.group = Group.new
		match.save!
	end

	test "interesting_status_change should return true if a reject becomes an accept" do
		@i.status = Invitation::STATUSES[:rejected]
		@i.save!

 		@i.status = Invitation::STATUSES[:accepted]
		assert InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return true if an accept becomes a reject" do
		@i.status = Invitation::STATUSES[:accepted]
		@i.save!

		@i.status = Invitation::STATUSES[:rejected]
		assert InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return true if an accept becomes a pending" do
		@i.status = Invitation::STATUSES[:accepted]
		@i.save!

		@i.status = Invitation::STATUSES[:pending]
		assert InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return false if a reject becomes a pending" do
		@i.status = Invitation::STATUSES[:rejected]
		@i.save!

		@i.status = Invitation::STATUSES[:pending]
		assert !InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return false if a pending becomes a reject" do
		@i.status = Invitation::STATUSES[:pending]
		@i.save!

		@i.status = Invitation::STATUSES[:reject]
		assert !InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return true if num additional players increases" do
		@i.status = Invitation::STATUSES[:accepted]
		@i.save!

		@i.num_additional_players = 1
		assert InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return true if num additional players decreases" do
		@i.status = Invitation::STATUSES[:accepted]
		@i.num_additional_players = 1
		@i.save!

		@i.num_additional_players = 0
		assert InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return false if a change in num additional players decreases cancels a rejection" do
		@i.status = Invitation::STATUSES[:accepted]
		@i.num_additional_players = 0
		@i.save!

		@i.status = Invitation::STATUSES[:rejected]
		@i.num_additional_players = 1
		assert !InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return false if a change in num additional players decreases cancels an acceptance" do
		@i.status = Invitation::STATUSES[:rejected]
		@i.num_additional_players = 1
		@i.save!

		@i.status = Invitation::STATUSES[:accepted]
		@i.num_additional_players = 0
		assert !InvitationObserver.interesting_status_change(@i)
	end

	test "interesting_status_change should return true if a change in num additional players sums to a change in status" do
		@i.status = Invitation::STATUSES[:accepted]
		@i.num_additional_players = 1
		@i.save!

		@i.status = Invitation::STATUSES[:rejected]
		@i.num_additional_players = 0
		assert InvitationObserver.interesting_status_change(@i)
	end


end