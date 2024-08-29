class UserProduct < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: { scope: :product_name, message: "はこの商品に対して既に欲しさレベルを設定しています。" }
end
