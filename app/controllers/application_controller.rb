class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def not_found_response(exception)
    render json: ErrorSerializer.new(ErrorMessage.new(exception.message, 404))
      .serialize_json, status: :not_found
  end

  def validation_failed(errors)
    render json: ErrorSerializer.new(ErrorMessage.new(errors.full_messages.join(', '), 400)).serialize_json, status: :bad_request
  end
end
