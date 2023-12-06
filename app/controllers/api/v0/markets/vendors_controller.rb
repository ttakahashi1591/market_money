class Api::V0::Markets::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    vendors = Market.find(params[:market_id]).vendors
    render json: VendorSerializer.new(vendors)
  end

  private

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end