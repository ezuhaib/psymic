require 'test_helper'

class SynapsedefsControllerTest < ActionController::TestCase
  setup do
    @synapsedef = synapsedefs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:synapsedefs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create synapsedef" do
    assert_difference('Synapsedef.count') do
      post :create, synapsedef: { class: @synapsedef.class, def: @synapsedef.def, synapse: @synapsedef.synapse }
    end

    assert_redirected_to synapsedef_path(assigns(:synapsedef))
  end

  test "should show synapsedef" do
    get :show, id: @synapsedef
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @synapsedef
    assert_response :success
  end

  test "should update synapsedef" do
    put :update, id: @synapsedef, synapsedef: { class: @synapsedef.class, def: @synapsedef.def, synapse: @synapsedef.synapse }
    assert_redirected_to synapsedef_path(assigns(:synapsedef))
  end

  test "should destroy synapsedef" do
    assert_difference('Synapsedef.count', -1) do
      delete :destroy, id: @synapsedef
    end

    assert_redirected_to synapsedefs_path
  end
end
