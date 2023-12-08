class Api::V0::Markets::SearchController < ApplicationController
  def index
    if params[:city] && !params[:state]
      render json: ErrorSerializer.new(ErrorMessage.new("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.", 422))
      .invalid_params, status: 422
    else
      render json: MarketSerializer.new(Market.search(params))
    end
  end
end