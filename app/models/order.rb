class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy

  attr_accessible :address, :email, :name, :pay_type_id, :ship_date

  PAYMENT_TYPES = [ "Check", "Credit card", "Purchase order" ]

  validates :name, :address, :email, presence: true
  validates :pay_type_id, presence: true

  after_update :notify_on_ship_date_change

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  private
    def notify_on_ship_date_change
      if ship_date_changed?
        OrderNotifier.shipped(self).deliver
      end
    end
end
