class UserProductsController < ApplicationController
  before_action :set_user_product, only: [:destroy]

  def index
    @user_products = UserProduct.all
    # フィルタリング
    @user_products = @user_products.where(gender: params[:gender]) if params[:gender].present?
    @user_products = @user_products.where(age: age_range) if params[:age_group].present?
    @user_products = @user_products.where(prefecture: params[:prefecture]) if params[:prefecture].present? && params[:prefecture] != '全て'
    @user_products = @user_products.where(city: params[:city]) if params[:city].present? && params[:city] != '全て'
  
    Rails.logger.debug "Filtered User Products: #{@user_products.pluck(:product_name, :gender, :age, :prefecture, :city)}"
  
    # 性別フィルタリング
    if params[:gender].present?
      @user_products = @user_products.where(gender: params[:gender])
    end
  
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
  
    # 都道府県フィルタリング
    if params[:prefecture].present? && params[:prefecture] != '全て'
      @user_products = @user_products.where(prefecture: params[:prefecture])
    end
  
    # 市区町村フィルタリング
    if params[:city].present? && params[:city] != '全て'
      @user_products = @user_products.where(city: params[:city])
    end
  
    # 重み付けスコアの計算
    weighted_scores = {}
    @user_products.each do |user_product|
      product_name = user_product.product_name
      score = case user_product.desire_level
              when 3
                3 # Must have!!
              when 2
                2 # Would Like
              when 1
                1 # Nice to Have
              else
                0
              end
  
      if weighted_scores[product_name]
        weighted_scores[product_name][:score] += score
        weighted_scores[product_name][:count] += 1
      else
        weighted_scores[product_name] = {
          score: score,
          count: 1,
          image_url: user_product.image_url,
          item_url: user_product.item_url,
          desire_level: user_product.desire_level
        }
      end
    end
  
    sorted_products = weighted_scores.sort_by { |_product_name, data| -data[:score] }
  
    render json: sorted_products.map { |product_name, data| 
      {
        product_name: product_name,
        score: data[:score],
        count: data[:count],
        image_url: data[:image_url],
        item_url: data[:item_url],
        desire_level: data[:desire_level]
      }
    }
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
