class MatchesController < ApplicationController
  # authorize current and show actions to anybody, even if not logged in
  skip_before_filter :login_required, :only => [:current, :show, :index]
  
  # GET /matches
  # GET /matches.xml
  # GET/matches.rss
  # GET/maches.atom
  def index
    @matches = Match.find(:all, :order => 'date DESC')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matches }
      format.atom 
    end
  end

  def current
    current = Match.current_match || Match.find(:first, :order => 'date DESC')
    if !current.nil?
      redirect_to match_path(Match.current_match)
    else
      flash[:notice] = 'No open matches found!'
      redirect_to :action => :index
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
    @match = Match.clone_match_from_last_one
    
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
    @match = Match.new(params[:match])

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
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(matches_url) }
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
