require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
  end

  test "should get index" do
    get admin_users_path
    assert_response :success
  end

  test "should get show" do
    get admin_user_path(users(:one))
    assert_response :success
  end
end
