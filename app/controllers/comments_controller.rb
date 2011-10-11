class CommentsController < ApplicationController
  skip_before_filter :login_required, :only => [:new, :create]

  def new
  	@match = Match.find(params[:match_id])
    @invitation = Invitation.find_by_code(params)
    if @invitation && @match.id == @invitation.match.id
      @match = @invitation.match
    else
      flash[:notice] = 'No invitation confirmation code provided while trying to post comments'
      redirect_to home_path
    end
  end

  def create
  	@match = Match.find(params[:match_id])
    @invitation = Invitation.find_by_code(params)
    if @invitation && @match.id == @invitation.match.id
      @match = @invitation.match
      @match.add_comment(@invitation.player, params[:comment][:body])
      redirect_to @match
    else
      flash[:notice] = 'No (or bad) invitation confirmation code provided while trying to post comments'
      redirect_to home_path
    end
  end
end
