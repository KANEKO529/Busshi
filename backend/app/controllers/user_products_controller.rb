class UserProductsController < ApplicationController
  before_action :set_user_product, only: [:destroy]

  def index
    @user_products = UserProduct.all

    # 年齢層フィルタリング
    if params[:age_group].present?
      age_range = case params[:age_group]
                  when 'teens'
                    10..19
                  when 'twenties'
                    20..29
                  when 'thirties'
                    30..39
                  when 'forties'
                    40..49
                  when 'fifties'
                    50..59
                  when 'sixties_and_above'
                    60..Float::INFINITY
                  else
                    0..Float::INFINITY
                  end

      @user_products = @user_products.where(age: age_range)
    end

    render json: @user_products
  end

  def create
    @user_product = UserProduct.new(user_product_params)

    existing_product = UserProduct.find_by(user_id: @user_product.user_id, product_name: @user_product.product_name)

    if existing_product
      render json: { errors: ['既にこの商品には欲しさレベルが設定されています。'] }, status: :unprocessable_entity
    else
      if @user_product.save
        render json: @user_product, status: :created
      else
        Rails.logger.error("Validation errors: #{@user_product.errors.full_messages}")
        render json: { errors: @user_product.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @user_product.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User product not found" }, status: :not_found
  end

  private

  def set_user_product
    @user_product = UserProduct.find(params[:id])
  end

  def user_product_params
    params.require(:user_product).permit(:user_id, :product_name, :item_url, :image_url, :price, :review_score, :desire_level, :gender, :age, :prefecture, :city)
  end
end
