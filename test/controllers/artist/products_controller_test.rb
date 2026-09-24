require "test_helper"

class Artist::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = sign_in_as_artist
    @product = Product.create!(
      name: "Producto del artista",
      description: "Descripción",
      price: 10,
      stock: 1,
      artist: @artist,
      category: categories(:one)
    )
  end

  test "should get index" do
    get artist_products_path
    assert_response :success
  end

  test "should get show" do
    get artist_product_path(@product)
    assert_response :success
  end

  test "should get new" do
    get new_artist_product_path
    assert_response :success
  end

  test "should get edit" do
    get edit_artist_product_path(@product)
    assert_response :success
  end
end
