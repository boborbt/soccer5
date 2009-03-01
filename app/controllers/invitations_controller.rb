class InvitationsController < ApplicationController 
  # authorize actions to anybody, even if not logged in  
  skip_before_filter :login_required, :only => [:accept_invitation, :reject_invitation]
  
  def accept_invitation
    @invitation = Invitation.find_by_acceptance_code(params[:id])
    if @invitation.nil?
      flash[:notice] = 'The acceptance code you provided is invalid!'
      return
    end
    
    @invitation.accept
    @invitation.save!
    flash[:notice] = 'Yuppie! See you on the playfield.'
  end

  def reject_invitation
    @invitation = Invitation.find_by_refusal_code(params[:id])
    if @invitation.nil?
      flash[:notice] = 'The  rejection code you provided is invalid!'      
      return
    end
    
    @invitation.reject
    @invitation.save!
    flash[:notice] = 'Thanks anyway. Hope to see you next time.'
  end
  
  def action_links
    @invitations=Invitation.find(:all)
  end

end
