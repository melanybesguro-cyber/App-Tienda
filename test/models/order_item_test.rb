require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  test "requires a positive quantity" do
    order_item = order_items(:one)
    order_item.quantity = 0

    assert_not order_item.valid?
    assert_includes order_item.errors[:quantity], "must be greater than 0"
  end

  test "accepts a zero unit price" do
    order_item = order_items(:one)
    order_item.unit_price = 0

    assert order_item.valid?
  end
end
