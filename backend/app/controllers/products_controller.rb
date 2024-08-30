# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  def search
    items = RakutenWebService::Ichiba::Item.search(keyword: params[:keyword], hits: 10)

    # 各アイテムを手動でハッシュ形式に変換
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

    render json: result
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end
end
