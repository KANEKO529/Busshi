# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def search
    # Rakuten APIから商品を検索
    items = RakutenWebService::Ichiba::Item.search(keyword: params[:keyword], hits: 10)

    # 検索結果をハッシュ形式に変換
    result = items.map do |item|
      {
        itemCode: item['itemCode'],
        itemName: item['itemName'],
        itemPrice: item['itemPrice'],
        itemUrl: item['itemUrl'],
        mediumImageUrls: item['mediumImageUrls'],
        shopName: item['shopName'],
        genreId: item['genreId'],
        reviewAverage: item['reviewAverage']
      }
    end

    # 年齢層フィルタリングが指定されている場合
    if params[:age_group].present?
      # フィルタリングに使用する年齢範囲を取得
      age_range = age_range_for_group(params[:age_group])

      # UserProductからフィルタリングされた年齢層の商品を取得
      filtered_product_names = UserProduct.where(age: age_range).pluck(:product_name)

      # 結果をフィルタリング
      result = result.select { |item| filtered_product_names.include?(item[:itemName]) }
    end

    render json: result
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  # 年齢層に応じた年齢範囲を返すヘルパーメソッド
  def age_range_for_group(age_group)
    case age_group
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
  end
end
