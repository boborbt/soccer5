class CommunicationsMailer < ActionMailer::Base
  

  def freeform_mail(recipient_list, subject_text, body_text, sent_at = Time.now)
    subject    subject_text
    recipients recipient_list
    from       'boborbt@gmail.com'
    sent_on    sent_at
    
    body       :body_text => body_text
  end

end
