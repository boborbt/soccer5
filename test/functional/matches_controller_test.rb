require 'test_helper'

class MatchesControllerTest < ActionController::TestCase
  fixtures :locations, :matches
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:matches)
  end
  
  test "/ should redirect to show current match" do
    get :current
    assert_redirected_to match_path(matches(:match))
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create match" do
    assert_difference('Match.count') do
      post :create, :match => { :location => locations(:sporting) }
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
    assert_difference('Match.count', -1) do
      delete :destroy, :id => matches(:match).id
    end

    assert_redirected_to matches_path
  end
end
