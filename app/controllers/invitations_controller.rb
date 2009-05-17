class InvitationsController < ApplicationController 
  # authorize actions to anybody, even if not logged in  
  skip_before_filter :login_required, :only => [:accept_invitation, :reject_invitation, :set_additional_players]
  
  def accept_invitation
    begin
      @invitation = Invitation.find_by_acceptance_code(params[:id])
      if @invitation.nil?
        flash[:notice] = 'The acceptance code you provided is invalid!'
        return
      end
    
      @invitation.accept
      @invitation.save!
      flash[:notice] = 'Yuppie! See you on the playfield.'
    rescue InvitationError
      flash[:notice] = 'A problem occurred:' + $!.message
      logger.info(flash[:notice])
    end
  end
  
  
  def set_additional_players
    begin
      @invitation = nil
      if !params[:acceptance_code].nil?
        @invitation = Invitation.find_by_acceptance_code(params[:acceptance_code])
      elsif !params[:refusal_code].nil?
        @invitation = Invitation.find_by_refusal_code(params[:refusal_code])        
      end
      
      raise InvitationError.new("No acceptance nor refusal code found!") if @invitation.nil?
      
      if @invitation.nil?
        flash[:notice] = 'The acceptance code you provided is invalid!'
        return
      end
    
      num_additional_players = 0
    
      unless params[:num_additional_players].nil?
        num_additional_players = params[:num_additional_players].to_i
      end
      
      @invitation.num_additional_players = num_additional_players
      @invitation.save!
      redirect_to group_current_match_path(@invitation.match.group)
    rescue InvitationError
      redirect_to group_current_match_path(@invitation.match.group)
      flash[:notice] = 'A problem occurred:' + $!.message
      logger.info(flash[:notice])
    end    
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
  
  def force_accept
    @invitation = Invitation.find(params[:id])
    @invitation.accept
    @invitation.save!
    @match = @invitation.match
    render :partial => 'matches/players_list'
  end

  def force_reject
    @invitation = Invitation.find(params[:id])
    @invitation.reject
    @invitation.save!
    @match = @invitation.match
    render :partial => 'matches/players_list'
  end

  
  def action_links
    @invitations=Invitation.find(:all)
  end

end
