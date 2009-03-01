class InvitationsMailer < ActionMailer::Base
  def invitation(invitation, sent_at = Time.now)
    subject    "Sei stato nominato! (Partita del #{invitation.match.date.to_s} ore #{invitation.match.time.to_s})"
    recipients invitation.player.email
    from       'boborbt@gmail.com'
    sent_on    sent_at
    
    body       :invitation => invitation
  end
end
