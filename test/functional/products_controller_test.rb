# encoding: utf-8

require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @update = {
      title: 'Lorem Ipsum',
      description: 'Wibbles are fun!',
      image_url: 'lorem.jpg',
      price: 19.95
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)

    assert_select '.list_image', 3
  end

  test "should get index in Spanish" do
    get :index, locale: 'es'
    assert_response :success
    assert_not_nil assigns(:products)

    assert_select '.list_image', 1

    I18n.locale = 'en'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: @update
    end

    assert_redirected_to product_path(assigns(:product))
  end

  test "should show product" do
    get :show, id: @product
    assert_response :success

    assert_select 'a', :href => edit_product_path(@product)
    assert_match /Price:(.+)\$9/m, response.body
  end

  test "should show product in Spanish" do
    get :show, id: @product, locale: 'es'
    assert_response :success

    assert_select 'a', :href => edit_product_path(@product)
    assert_match /Price:(.+)€/m, response.body

    I18n.locale = 'en'
  end

  test "should get edit" do
    get :edit, id: @product
    assert_response :success
  end

  test "should update product" do
    put :update, id: @product, product: @update
    assert_redirected_to product_path(assigns(:product))
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product
    end

    assert_redirected_to products_path
  end

  test "should get who_bought" do
    get :who_bought, id: @product
    assert_response :success
  end

  [:json, :xml, :atom].each do |format|
    test "should get who_bought via #{format}" do
      basic_login_as :one

      get :who_bought, id: @product, format: format
      assert_response :success
    end
  end
end
