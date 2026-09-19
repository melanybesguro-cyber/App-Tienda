require "test_helper"

class Artist::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get artist_products_index_url
    assert_response :success
  end

  test "should get show" do
    get artist_products_show_url
    assert_response :success
  end

  test "should get new" do
    get artist_products_new_url
    assert_response :success
  end

  test "should get edit" do
    get artist_products_edit_url
    assert_response :success
  end
end
