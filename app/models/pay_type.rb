class PayType < ActiveRecord::Base
  attr_accessible :name

  def translated_name
    I18n.t(name, scope: 'orders.form.pay_type')
  end
end
