class AddItemCodeToUserProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :user_products, :item_code, :string
  end
end
