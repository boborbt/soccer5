require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  def setup
    login_as :admin
  end
  
  test "should get index if root" do
    get :index
    assert_response :success
    assert_not_nil assigns(:locations)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post :create, :location => { }
    end

    assert_redirected_to location_path(assigns(:location))
  end

  test "should show location" do
    get :show, :id => locations(:sporting).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => locations(:sporting).id
    assert_response :success
  end

  test "should update location" do
    put :update, :id => locations(:sporting).id, :location => { }
    assert_redirected_to location_path(assigns(:location))
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      delete :destroy, :id => locations(:sporting).id
    end

    assert_redirected_to locations_path
  end
end
