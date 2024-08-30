class GenresController < ApplicationController
  def index
    query = params[:genre_id]
    response = HTTParty.get("https://app.rakuten.co.jp/services/api/IchibaGenre/Search/20140222",
                            query: {
                              format: 'json',
                              applicationId: ENV['RAKUTEN_APP_ID'],
                              genreId: query || 0
                            })
                            if response.success?
                              @genres = response['children']
                              render json: @genres
                            else
                              render json: { error: 'APIリクエストに失敗しました' }, status: :bad_request
                            end
  end

end
