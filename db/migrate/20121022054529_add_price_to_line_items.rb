class AddPriceToLineItems < ActiveRecord::Migration
  def up
    add_column :line_items, :price, :decimal

    LineItem.all.each do |item|
      item.price = item.product.price
      item.save
    end
  end

  def down
    remove_column :line_items, :price
  end
end
