require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "requires a name and description" do
    category = Category.new

    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
    assert_includes category.errors[:description], "can't be blank"
  end
end
