require "test_helper"

class Admin::CommissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
  end

  test "should get index" do
    get admin_commissions_path
    assert_response :success
  end

  test "should get show" do
    get admin_commission_path(commissions(:one))
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_commission_path(commissions(:one))
    assert_response :success
  end
end
