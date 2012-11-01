class StoreController < ApplicationController
  skip_before_filter :authorize

  before_filter :increment_counter

  def index
    if params[:set_locale]
      redirect_to store_path(locale: params[:set_locale])
    else
      @products = Product.order(:title)
      @cart = current_cart
    end
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
