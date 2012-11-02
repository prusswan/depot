class AddLocaleToProducts < ActiveRecord::Migration
  def change
    add_column :products, :locale, :string, default: 'en'
  end
end
