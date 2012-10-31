class ApplicationController < ActionController::Base
  before_filter :authorize

  protect_from_forgery

  protected
    def authorize
      case request.format
      when Mime::HTML
        signed_in = User.find_by_id(session[:user_id])
      else
        signed_in = authenticate_or_request_with_http_basic do |name, password|
          user = User.find_by_name(name)
          user && user.authenticate(password)
        end
      end

      redirect_to login_url, notice: "Please log in" unless signed_in
    end

  private
    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
end
