require 'test_helper'

class MindlogsControllerTest < ActionController::TestCase
  setup do
    @mindlog = mindlogs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mindlogs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mindlog" do
    assert_difference('Mindlog.count') do
      post :create, mindlog: { description: @mindlog.description, title: @mindlog.title }
    end

    assert_redirected_to mindlog_path(assigns(:mindlog))
  end

  test "should show mindlog" do
    get :show, id: @mindlog
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mindlog
    assert_response :success
  end

  test "should update mindlog" do
    put :update, id: @mindlog, mindlog: { description: @mindlog.description, title: @mindlog.title }
    assert_redirected_to mindlog_path(assigns(:mindlog))
  end

  test "should destroy mindlog" do
    assert_difference('Mindlog.count', -1) do
      delete :destroy, id: @mindlog
    end

    assert_redirected_to mindlogs_path
  end
end
