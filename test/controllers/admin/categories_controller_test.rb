require "test_helper"

class Admin::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin
  end

  test "should get index" do
    get admin_categories_path
    assert_response :success
  end

  test "should get show" do
    get admin_category_path(categories(:one))
    assert_response :success
  end

  test "should get new" do
    get new_admin_category_path
    assert_response :success
  end

  test "should get edit" do
    get edit_admin_category_path(categories(:one))
    assert_response :success
  end
end
