require "test_helper"

class Admin::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
  end

  test "should get index" do
    get admin_orders_path
    assert_response :success
  end

  test "should get show" do
    get admin_order_path(orders(:one))
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_order_path(orders(:one))
    assert_response :success
  end
end
