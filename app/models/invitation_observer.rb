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
	return unless (invitation.num_additional_players_changed? || invitation.status_changed?)
		
	InvitationsMailer.deliver_match_update_info(invitation)
	invitation.match.invitations.each { |i| i.increment_sent_mails } 
  end	
end