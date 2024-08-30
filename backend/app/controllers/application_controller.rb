class ApplicationController < ActionController::API
  def test
    render json: { message: 'This is a test message from Rails' }
  end

  def search
    query = params[:query]
    response = HTTParty.get("https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706",
                            query: {
                              format: 'json',
                              applicationId: ENV['RAKUTEN_APP_ID'],
                              keyword: query
                            })
    render json: response.parsed_response
  end
end
