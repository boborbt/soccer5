class InvitationObserver < ActiveRecord::Observer
  def before_create(invitation)
  	player = invitation.player
  	match  = invitation.match

   	invitation.acceptance_code = Digest::SHA1.hexdigest( 'acceptance' + player.name + match.id.to_s )
    invitation.refusal_code =  Digest::SHA1.hexdigest( 'rejection' + player.name + match.id.to_s )
  end
  
  def after_create(invitation)
  	player = invitation.player
  	match  = invitation.match

    if player.autoaccept_invitations(match)
      invitation.accept
    end
    
    InvitationsMailer.deliver_invitation(invitation)
    invitation.number_of_sent_mails += 1
    invitation.save!
  end

  def after_save(invitation)
  	return if invitation.match.status != Match::STATUSES[:closed]
  	return unless InvitationObserver.interesting_status_change(invitation)
    	
  	InvitationsMailer.deliver_match_update_info(invitation)
  	invitation.match.unrejected_invitations.each { |i| i.increment_sent_mails } 
  end

  # The status change is interesting if it actually changed the number of
  # players for the match.
  def InvitationObserver.interesting_status_change(invitation)
    diff_in_players_count  = invitation.num_additional_players - invitation.num_additional_players_was
    diff_in_players_count += 1 if invitation.status_changed? && invitation.status == Invitation::STATUSES[:accepted]
    diff_in_players_count -= 1 if invitation.status_changed? && invitation.status_was == Invitation::STATUSES[:accepted]
    
    return diff_in_players_count != 0 && !invitation.match.interested_players.blank?
  end
end