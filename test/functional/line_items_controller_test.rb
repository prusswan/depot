require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:one)
    @line_item.cart = carts(:one)
    @line_item.save
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, product_id: products(:ruby).id
    end

    assert_redirected_to store_path
  end

  test "should create line_item via ajax" do
    assert_difference('LineItem.count') do
      xhr :post, :create, product_id: products(:ruby).id
    end

    assert_response :success
    assert_select_jquery :html, '#cart' do
      assert_select 'tr#current_item td', /Programming Ruby 1.9/
    end
  end

  test "should show line_item" do
    get :show, id: @line_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @line_item
    assert_response :success
  end

  test "should update line_item" do
    put :update, id: @line_item, line_item: { cart_id: @line_item.cart_id }
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should not update line_item (with product_id)" do
    assert_raise do
      put :update, id: @line_item, line_item: { cart_id: @line_item.cart_id, product_id: @line_item.product_id }
    end
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      delete :destroy, id: @line_item
    end

    assert_redirected_to store_url
  end

  test "should destroy line_item via ajax" do
    basic_login_as :one

    assert_difference('LineItem.count', -1) do
      xhr :delete, :destroy, id: @line_item
    end

    assert_response :success
  end

  test "should decrement line_item via ajax" do
    basic_login_as :one

    @line_item.quantity = 3
    @line_item.product = products(:ruby)
    @line_item.save

    assert_difference('LineItem.find(@line_item).quantity', -1) do
      xhr :post, :decrement, id: @line_item
    end

    assert_response :success
  end
end
