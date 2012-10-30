require 'test_helper'

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:two)
  end

  test "multiple unique products can be added" do
    assert_difference('@cart.line_items.size', 2) do
      @cart.add_product(products(:ruby).id)
      @cart.add_product(products(:one).id)

      assert_equal products(:one).price + products(:ruby).price, @cart.total_price
    end
  end

  test "multiple duplicate products can be added" do
    assert_difference('@cart.line_items.size', 2) do
      2.times { @cart.add_product(products(:ruby).id) }
      assert_equal 2 * products(:ruby).price, @cart.total_price
    end
  end
end
