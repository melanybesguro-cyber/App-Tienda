require "test_helper"

class Customer::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer = User.create!(
      name: "Cliente de prueba",
      email: "customer-orders@example.com",
      password: "password",
      role: "customer"
    )
    @artist = User.create!(
      name: "Artista de prueba",
      email: "artist-orders@example.com",
      password: "password",
      role: "artist"
    )
    @category = Category.create!(name: "Categoría de prueba", description: "Descripción")
    @product = Product.create!(
      name: "Producto de prueba",
      description: "Descripción",
      price: 100,
      stock: 2,
      artist: @artist,
      category: @category
    )

    post customer_login_path, params: {
      email: @customer.email,
      password: "password"
    }
  end

  test "does not create an order when requested quantity exceeds stock" do
    assert_no_difference("Order.count") do
      post customer_orders_path, params: {
        product_id: @product.id,
        quantity: 3
      }
    end

    assert_equal 2, @product.reload.stock
    assert_redirected_to customer_root_path
    assert_equal "No hay stock suficiente. Disponible: 2.", flash[:alert]
  end

  test "creates an order and decrements stock" do
    assert_difference("Order.count", 1) do
      post customer_orders_path, params: {
        product_id: @product.id,
        quantity: 2
      }
    end

    assert_equal 0, @product.reload.stock
    assert_redirected_to customer_root_path
    assert_equal "Pedido creado correctamente.", flash[:notice]
  end
end
