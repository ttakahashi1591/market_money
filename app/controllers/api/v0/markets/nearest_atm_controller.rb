class Api::V0::Markets::NearestAtmsController < ApplicationController
  def index
    begin
      market = Market.find(params[:market_id])
      
      render json: AtmSerializer.new(AtmFacade.new(market).nearest_atms)
    rescue ActiveRecord::RecordNotFound => exception
      render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
    end
  end
end