class Api::V0::MarketVendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def create
    create_market_vendor = MarketVendor.new(market_vendor_params)

    if create_market_vendor.save
      render json: { message: "Successfully added vendor to market" }, status: :created
    else
      validation_failed(create_market_vendor.errors)
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def validation_failed(errors)
    render json: ErrorSerializer.new(ErrorMessage.new(errors.full_messages.join(', '), 404)).serialize_json, status: :bad_request
  end
end