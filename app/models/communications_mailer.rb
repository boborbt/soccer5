class CommunicationsMailer < ActionMailer::Base
  

  def freeform_mail(recipient_list, subject_text, body_text, sent_at = Time.now)
    subject    subject_text
    recipients recipient_list
    from       'boborbt@gmail.com'
    sent_on    sent_at
    
    body       :body_text => body_text
  end

  def comment(comment_obj)
  	subject 	"Partita del #{comment_obj.match.date.to_s}, nuovo commento di #{comment_obj.player.name}"
  	recipients  comment_obj.match.interested_players.map { |p| p.email }
  	from        'boborbt@gmail.com'
  	sent_on		Time.now

  	body  		:body_text => comment_obj.body, :player => comment_obj.player.name, :match => comment_obj.match
  end

end
