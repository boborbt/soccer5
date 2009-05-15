class MatchesController < ApplicationController
  # authorize current and show actions to anybody, even if not logged in
  skip_before_filter :login_required, :only => [:current, :show, :index, :last]
  
  # GET /matches
  # GET /matches.xml
  # GET/matches.rss
  # GET/maches.atom
  def index
    @group = Group.find(params[:group_id])
    @matches = @group.matches.find(:all, :order => 'date DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matches }
      format.atom 
    end
  end

  def current
    group = Group.find(params[:id])
    current = Match.current_match(group)
    if !current.nil?
      redirect_to match_path(current)
    else
      flash[:notice] = 'No open matches found!'
      redirect_to home_path
    end
  end
  
  def last
    group = Group.find(params[:id])
    match = Match.last_match(group)
    
    if !match.nil?
      redirect_to match_path(match)
    else
      flash[:notice] = 'No open matches found!'
      redirect_to home_path
    end
  end
   

  # GET /matches/1
  # GET /matches/1.xml
  def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/new
  # GET /matches/new.xml
  def new
    @group = Group.find(params[:group_id])
    @match = Match.clone_match_from_last_one(@group)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/1/edit
  def edit
    @match = Match.find(params[:id])
  end

  # POST /matches
  # POST /matches.xml
  def create
    @group = Group.find(params[:group_id])
    @match = Match.new(params[:match])
    @match.group = @group

    respond_to do |format|
      if @match.save
        flash[:notice] = 'Match was successfully created.'
        format.html { redirect_to(@match) }
        format.xml  { render :xml => @match, :status => :created, :location => @match }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /matches/1
  # PUT /matches/1.xml
  def update
    @match = Match.find(params[:id])

    respond_to do |format|
      if @match.update_attributes(params[:match])
        flash[:notice] = 'Match was successfully updated.'
        format.html { redirect_to(@match) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @match.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.xml
  def destroy
    @match = Match.find(params[:id])
    @group = @match.group
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(group_matches_url(@group)) }
      format.xml  { head :ok }
    end
  end
  
  # --------------------------------------------------------------------------------
  # NON CRUD 
  # --------------------------------------------------------------------------------

  def invite_player
    @match = Match.find(params[:id])
    @player = Player.find(params[:player_id])
    @match.players << @player
    render :partial => 'players_list'
  end
  
  def uninvite_player
    @match = Match.find(params[:id])
    @player = Player.find(params[:player_id])
    @match.players.delete( @player )
    render :partial => 'players_list'
  end
  
  
  def autoinvite_players
    @match = Match.find(params[:id])
    @match.autoinvite_players!
    render :partial => 'players_list'
  end
  
  def solicit_players
    @match = Match.find(params[:id])
    @match.solicit_players!
    render :text => 'Mails have been sent!'
  end
  
  
  def close_convocations
    @match = Match.find(params[:id])
    @match.close_convocations!
    render :action => 'show', :id => @match
  end
  
  def reopen_convocations
    @match = Match.find(params[:id])
    @match.reopen_convocations!
    render :action => 'show', :id => @match
  end
  
end
