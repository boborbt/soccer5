class GroupsController < ApplicationController
  skip_before_filter :login_required
  
  
  def index
    @groups = Group.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  
  # GET /groupes/1
  # GET /groupes/1.xml
  def show
    @group = Group.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groupes/new
  # GET /groupes/new.xml
  def new
    @group = Group.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end

  # GET /groupes/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groupes
  # POST /groupes.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Group was successfully created.'
        format.html { redirect_to(@group) }
        format.xml  { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groupes/1
  # PUT /groupes/1.xml
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = 'Group was successfully updated.'
        format.html { redirect_to(@group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /groupes/1
  # DELETE /groupes/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml  { head :ok }
    end
  end
  
  # player list methods
  def add_player
    group  = Group.find(params[:id])
    player = Player.find(params[:player_id])
    group.players << player unless group.players.include?(player)
    render :partial => 'player_list', :locals => { :group => group }
  end
  
  def remove_player
    group  = Group.find(params[:id])
    player = Player.find(params[:player_id])
    group.players.delete(player)
    render :partial => 'player_list', :locals => { :group => group }    
  end
  
  def toggle_autoinvite
    group = Group.find(params[:id])
    player = Player.find(params[:player_id])
    grouping = group.groupings.find_by_player_id(player)
    grouping.autoinvite = !grouping.autoinvite
    grouping.save!
    group.save!
    render :partial => 'player_list', :locals => { :group => group }
  end
  
end
