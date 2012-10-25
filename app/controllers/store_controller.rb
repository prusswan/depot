class StoreController < ApplicationController
  before_filter :increment_counter

  def index
    @products = Product.order(:title)
    @cart = current_cart
  end

  private
    def increment_counter
      if session[:counter].nil?
        session[:counter] = 1
      else
        session[:counter] += 1
      end
    end
end
