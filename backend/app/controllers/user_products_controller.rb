class UserProductsController < ApplicationController
  # before_action :authenticate_user!

  def index
    @user_products = UserProduct.all
    render json: @user_products
  end

  def create
    # 新しいuser_productオブジェクトを生成
    @user_product = UserProduct.new(user_product_params)

    # 既に同じユーザーが同じ商品に対して欲しさレベルを設定しているかをチェック
    existing_product = UserProduct.find_by(user_id: @user_product.user_id, product_name: @user_product.product_name)

    if existing_product
      # 既に設定されている場合はエラーメッセージを返す
      render json: { errors: ['既にこの商品には欲しさレベルが設定されています。'] }, status: :unprocessable_entity
    else
      # まだ設定されていない場合は保存する
      if @user_product.save
        render json: @user_product, status: :created
      else
        Rails.logger.error("Validation errors: #{@user_product.errors.full_messages}")
        render json: { errors: @user_product.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  private

  def user_product_params
    params.require(:user_product).permit(:user_id, :product_name, :item_url, :image_url, :price, :review_score, :desire_level, :gender, :age, :prefecture, :city)
  end
end
