require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  setup do
    default_url_options[:locale] = 'en'
  end

  # A user goes to the index page. They select a product, adding it to their
  # cart, and check out, filling in their details on the checkout form. When
  # they submit, an order is created containing their information, along with a
  # single line item corresponding to the product they added to their cart.
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_template "index"

    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders", order: {
      name: "Dave Thomas",
      address: "123 The Street",
      email: "dave@example.com",
      pay_type_id: 1
    }

    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
    assert_equal "Dave Thomas",      order.name
    assert_equal "123 The Street",   order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check",            PayType.find(order.pay_type_id).name
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
  end

  test "updating ship_date in order" do
    request_login_as(:one)

    get edit_order_url(orders(:one))
    assert_response :success
    assert_template "edit"

    put_via_redirect order_url(orders(:one)), order: {
      ship_date: Time.now
    }
    assert_response :success
    assert_template "show"

    mail = ActionMailer::Base.deliveries.last
    assert_equal "Pragmatic Store Order Shipped", mail.subject
  end

  test "updating ship_date without login" do
    get edit_order_url(orders(:one))
    assert_response :redirect
  end

  test "accessing non-existent order" do
    assert_raise do
      get '/orders/fake'

      mail = ActionMailer::Base.deliveries.last
      assert_equal "Pragmatic Store Order Shipped", mail.subject
      assert_match /Attempt to access invalid cart/, mail.body
    end
  end
end
