class InvitationsController < ApplicationController 
  # authorize actions to anybody, even if not logged in  
  skip_before_filter :login_required, :only => [:accept_invitation, :reject_invitation, :set_additional_players]

  def accept_invitation
    @invitation = Invitation.find_by_acceptance_code(params[:id])
    if @invitation.nil?
      @message = 'The acceptance code you provided is invalid!'
      return
    end

    @invitation.accept
    @invitation.save!
    @message = 'Yuppie! See you on the playfield.'
  rescue InvitationError
    flash[:error] = 'A problem occurred:' + $!.message
    logger.info(flash[:error])
  end


  def set_additional_players
    @invitation = Invitation.find_by_code(params)
    raise InvitationError.new("No acceptance nor refusal code found!") if @invitation.nil?
    
    @invitation.num_additional_players = params[:num_additional_players] && params[:num_additional_players].to_i || 0    
    @invitation.save!
    
    redirect_to group_current_match_path(@invitation.match.group)
  rescue InvitationError
    redirect_to group_current_match_path(@invitation.match.group)
    flash[:error] = 'A problem occurred:' + $!.message
    logger.info(flash[:error])
  end
  
  def add_friend
    @invitation = Invitation.find(params[:id])
    raise InvitationError.new("No invitation found (#{params[:id]})") if @invitation.nil?
    
    @invitation.num_additional_players ||= 0
    @invitation.num_additional_players += 1
    @invitation.save!
    
    @match = @invitation.match
    render :partial => 'matches/players_list'    
  rescue InvitationError
      flash[:error] = $!.message
      render :partial => 'matches/players_list', :locals => { :error => $!.message }
  end
  
  def remove_friend
      @invitation = Invitation.find(params[:id])
      raise InvitationError.new("No invitation found (#{params[:id]})") if @invitation.nil?

      @invitation.num_additional_players ||= 0
      @invitation.num_additional_players -= 1 unless @invitation.num_additional_players <= 0
      @invitation.save!

      @match = @invitation.match
      render :partial => 'matches/players_list'    
    rescue InvitationError
        flash[:error] = $!.message
        render :partial => 'matches/players_list', :locals => { :error => $!.message }    
  end

  def reject_invitation
    @invitation = Invitation.find_by_refusal_code(params[:id])
    if @invitation.nil?
      @message = 'The  rejection code you provided is invalid!'      
      return
    end

    @invitation.reject
    @invitation.save!
    @message = 'Thanks anyway. Hope to see you next time.'
  rescue
    flash[:error] = $!.message
  end

  def force_accept
    @invitation = Invitation.find(params[:id])
    @invitation.accept
    @invitation.save!
    @match = @invitation.match
    render :partial => 'matches/players_list'    
  rescue
    @match = @invitation.match
    render :partial => 'matches/players_list', :locals => { :error => $!.message }
  end

  def force_reject
    @invitation = Invitation.find(params[:id])
    @invitation.reject
    @invitation.save!
    @match = @invitation.match
    render :partial => 'matches/players_list'
  rescue
    flash[:error] = $!.message
    @match = @invitation.match
    render :partial => 'matches/players_list', :locals => { :error => $!.message }
  end


  def action_links
    @invitations=Invitation.find(:all)
  end

end
