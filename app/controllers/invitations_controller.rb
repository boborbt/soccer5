class InvitationsController < ApplicationController 
  def accept_invitation
    @invitation = Invitation.find_by_acceptance_code(params[:id])
    unless @invitation.nil?
      @invitation.accept
      @invitation.save!
      flash[:notice] = 'Yuppie! See you on the playfield.'
    else
      flash[:notice] = 'The acceptance code you provided is invalid!'
    end    
  end

  def reject_invitation
    @invitation = Invitation.find_by_refusal_code(params[:id])
    unless @invitation.nil?
      @invitation.reject
      @invitation.save!
      flash[:notice] = 'Thanks anyway. Hope to see you next time.'
      
    else
      flash[:notice] = 'The  rejection code you provided is invalid!'      
    end
  end

end
