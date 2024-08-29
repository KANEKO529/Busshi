class AddUniqueIndexToUserProducts < ActiveRecord::Migration[7.0]
  def change
    add_index :user_products, [:user_id, :product_name], unique: true
  end
end
