class RankingsController < ApplicationController
  def index
    begin
      @rankings = UserProduct
        .select("item_code, product_name, item_url, image_url, price, review_score, SUM(desire_level) as total_desire, COUNT(*) as vote_count")
        .group("item_code, product_name, item_url, image_url, price, review_score")
        .order("total_desire DESC")

      # フィルタリングオプションがあれば適用
      if params[:gender].present?
        @rankings = @rankings.where(gender: params[:gender])
      end

      if params[:age_group].present?
        case params[:age_group]
        when 'teens'
          @rankings = @rankings.where(age: 13..19)
        when 'twenties'
          @rankings = @rankings.where(age: 20..29)
        when 'thirties'
          @rankings = @rankings.where(age: 30..39)
        when 'forties'
          @rankings = @rankings.where(age: 40..49)
        when 'fifties'
          @rankings = @rankings.where(age: 50..59)
        when 'sixties'
          @rankings = @rankings.where(age: 60..69)
        end
      end

      if params[:prefecture].present?
        @rankings = @rankings.where(prefecture: params[:prefecture])
      end

      if params[:city].present?
        @rankings = @rankings.where(city: params[:city])
      end

      render json: @rankings
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
