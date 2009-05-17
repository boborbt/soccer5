require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  fixtures :locations, :matches
  
  def setup
    login_as(:admin)
  end
  
  test "should get index" do
    get :index, :group_id => groups(:one)
    assert_response :success
    assert_not_nil assigns(:matches)
  end
  
  test "/ should redirect to show current match" do
    match = matches(:match)
    match.date = Date.today
    match.save!
    
    get :current, :group_id => match.group.id
    assert_redirected_to match_path(matches(:match))
  end

  test "should get new" do
    get :new, :group_id => groups(:one)
    assert_response :success
  end
  
  test "new matches shoudl be 1 week after current match" do
    get :new, :group_id => groups(:one)
    assert_equal assigns(:match).date, Match.current_match(groups(:one)).date + 1.week
  end
  
  test "new matchees should be at the same time as the current match" do
    get :new, :group_id => groups(:one)
    assert_equal assigns(:match).time, Match.current_match(groups(:one)).time
  end
  
  test "new matches should be in the same place of the current match" do
    get :new, :group_id => groups(:one)
    assert_equal assigns(:match).location, Match.current_match(groups(:one)).location
  end

  test "should create match" do
    assert_difference('Match.count') do
      post :create, :match => { :location => locations(:sporting) }, :group_id => groups(:one)
    end

    assert_redirected_to match_path(assigns(:match))
  end

  test "should show match" do
    get :show, :id => matches(:match).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => matches(:match).id
    assert_response :success
  end

  test "should update match" do
    put :update, :id => matches(:match).id, :match => { }
    assert_redirected_to match_path(assigns(:match))
  end

  test "should destroy match" do
    match_group = matches(:match).group
    assert_difference('Match.count', -1) do
      delete :destroy, :id => matches(:match).id
    end

    assert_redirected_to group_matches_path(match_group)
  end
end
