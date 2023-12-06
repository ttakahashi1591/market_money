class Api::V0::VendorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response
  
  def show
    render json: VendorSerializer.new(Vendor.find(params[:id]))
  end

  def create
    create_vendor = Vendor.new(vendor_params)

    if create_vendor.save
      render json: VendorSerializer.new(create_vendor), status: :created
    else
      error = ErrorMessage.new("Validation failed: #{vendor.errors.full_messages.join(', ')}", 400)
      render json: ErrorSerializer.new(error).serialize_json, status: :bad_request
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end
end