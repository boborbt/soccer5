class InvitationsMailer < ActionMailer::Base
  def invitation(invitation, sent_at = Time.now)
    subject    "Sei stato nominato! (Partita del #{invitation.match.date.to_s} ore #{invitation.match.time.to_s})"
    recipients invitation.player.email
    from       'boborbt@gmail.com'
    sent_on    sent_at
    
    body       :invitation => invitation
  end
  
  def solicitation(invitation, sent_at = Time.now)
    subject    "Reminder convocazione (Partita del #{invitation.match.date.to_s} ore #{invitation.match.time.to_s})"
    recipients invitation.player.email
    from       'boborbt@gmail.com'
    sent_on    sent_at
    
    body       :invitation => invitation    
  end
  
  def close_convocations(invitation, sent_at = Time.now)
    subject     invitation.match.description + " - siamo in "+invitation.match.number_of_coming_players.to_s
    recipients  invitation.player.email
    from        'boborbt@gmail.com'
    sent_on     sent_at
    
    body        :accepted_invitations => invitation.match.accepted_invitations,
                :invitations_with_additional_players => invitation.match.invitations_with_additional_players
    
  end
end
