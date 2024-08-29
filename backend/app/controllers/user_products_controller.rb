class UserProductsController < ApplicationController
  # before_action :authenticate_user!

  def create
    @user_product = UserProduct.new(user_product_params)
    Rails.logger.debug("受け取ったデータ: #{@user_product.attributes}")
    if @user_product.save
      render json: @user_product, status: :created
    else
      Rails.logger.error("Validation errors: #{@user_product.errors.full_messages}")
      render json: { errors: @user_product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_product_params
    params.require(:user_product).permit(:user_id, :product_name, :item_url, :image_url, :price, :review_score, :desire_level, :gender, :age, :prefecture, :city, :item_code)
  end
end
