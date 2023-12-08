class ErrorMessage
  attr_reader :message, 
              :status_code

  def initialize(message, status_code)
    @message = message
    @status_code = status_code
  end

  def self.market_vendor_create_status(exception)
    if exception.message.include?("already exists")
      422
    else
      404
    end
  end
end