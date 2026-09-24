require "test_helper"

class ProductTest < ActiveSupport::TestCase
  test "is valid with the required attributes" do
    product = Product.new(
      name: "Producto de prueba",
      description: "Descripción del producto",
      price: 100,
      stock: 5,
      artist: User.new(role: "artist"),
      category: Category.new(name: "Categoría", description: "Descripción")
    )

    assert product.valid?
  end

  test "rejects a price that is not greater than zero" do
    product = products(:one)
    product.price = 0

    assert_not product.valid?
    assert_includes product.errors[:price], "must be greater than 0"
  end

  test "rejects negative stock" do
    product = products(:one)
    product.stock = -1

    assert_not product.valid?
    assert_includes product.errors[:stock], "must be greater than or equal to 0"
  end
end
