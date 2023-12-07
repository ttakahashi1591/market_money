class Api::V0::MarketVendorsController < ApplicationController  
  def create
    begin
      market_vendor = MarketVendor.create!(market_vendor_params)
      render json: MarketVendorSerializer.new(market_vendor), status: 201
    rescue ActiveRecord::RecordInvalid => exception
      market_id = exception.record.market_id
      vendor_id = exception.record.vendor_id
      if MarketVendor.find_by(market_id: market_id, vendor_id: vendor_id).present?
        existing_id_error_response(market_id, vendor_id)
      elsif market_id.nil? || vendor_id.nil?
        validation_error_response(exception)
      elsif market_id != nil && vendor_id != nil
        not_found_response(exception)
      end
    end
  end

  def destroy
    market_vendor = MarketVendor.find_by(market_vendor_params)
    market_id = market_vendor_params[:market_id]
    vendor_id = market_vendor_params[:vendor_id]
    
    if market_vendor.nil?
      delete_error_response(market_id, vendor_id)
    else
      render json: MarketVendor.delete(market_vendor), status: 204
    end
  end

  private

  def market_vendor_params
    params.require(:market_vendor).permit(:market_id, :vendor_id)
  end

  def validation_error_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 400))
      .serialize_json, status: :bad_request
  end

  def existing_id_error_response(market_id, vendor_id)
    render json: ErrorSerializer.new(ErrorMessage.new("Validation failed: Market vendor asociation between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists", 422))
    .serialize_json, status: :unprocessable_entity
  end

  def delete_error_response(market_id, vendor_id)
    render json: ErrorSerializer.new(ErrorMessage.new("Validation failed: Market vendor asociation between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists", 404))
    .serialize_json, status: 404
  end
end