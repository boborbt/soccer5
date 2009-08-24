class MailsController < ApplicationController
  def prepare
    @recipients = params[:recipients]
    @subject = params[:subject]
    @body = params[:body]
  end

  def deliver
    @recipients = params[:recipients]
    @subject = params[:subject]
    @body = params[:body]
    
    CommunicationsMailer.deliver_freeform_mail @recipients, @subject, @body
    redirect_to home_path
  end
end