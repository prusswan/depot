class CreatePayTypes < ActiveRecord::Migration
  def up
    create_table :pay_types do |t|
      t.string :name

      t.timestamps
    end

    add_column :orders, :pay_type_id, :integer

    Order::PAYMENT_TYPES.each do |pay_type|
      PayType.create(name: pay_type)
    end

    remove_column :orders, :pay_type
  end

  def down
    add_column :orders, :pay_type, :string

    Order.all.each do |order|
      order.pay_type = PayType.find(order.pay_type_id).name
      order.save
    end

    remove_column :orders, :pay_type_id

    drop_table :pay_types
  end
end
