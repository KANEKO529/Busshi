class UserProduct < ApplicationRecord
  belongs_to :user  # ここで 'user' モデルに関連付けます
  validates :user_id, :product_name, :item_url, :image_url, :price, :review_score, :desire_level, :gender, :age, :prefecture, :city, :item_code, presence: true
end