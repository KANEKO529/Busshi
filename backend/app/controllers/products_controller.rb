class ProductsController < ApplicationController
  def search
    keyword = params[:keyword]
    genre_id = params[:genreId]

    # リクエストのパラメータに応じて、Rakuten API に渡すオプションを決定します
    search_options = { hits: 30 }
    search_options[:keyword] = keyword if keyword.present?
    search_options[:genreId] = genre_id if genre_id.present?

    # Rakuten API から商品を検索
    items = RakutenWebService::Ichiba::Item.search(search_options)

    # 検索結果を整形
    result = items.map do |item|
      genre = RakutenWebService::Ichiba::Genre[item['genreId']] rescue nil

      parent_genre = genre&.parents&.first  # 親ジャンルが存在する場合、その最初のジャンルを取得

      {
        itemCode: item['itemCode'],
        itemName: item['itemName'],
        itemPrice: item['itemPrice'],
        itemUrl: item['itemUrl'],
        mediumImageUrls: item['mediumImageUrls'],
        shopName: item['shopName'],
        genreId: item['genreId'],
        genreName: genre ? genre['genreName'] : "Unknown",
        parentGenreId: parent_genre ? parent_genre['genreId'] : "N/A",
        parentGenreName: parent_genre ? parent_genre['genreName'] : "N/A",
        reviewAverage: item['reviewAverage']
      }
    end

    render json: result
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end
end
