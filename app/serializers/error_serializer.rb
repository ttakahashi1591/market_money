class ErrorSerializer
  def initialize(error_object)
    @error_object = error_object
  end

  def serialize_json
    {
      errors: [
        {
          status: @error_object.status_code.to_s,
          title: @error_object.message
        }
      ]
    }
  end

  def invalid_params
    {
      "errors": [
          {
              detail: @error_object.message
          }
        ]
      }
  end

  def no_market_vendor(market_id, vendor_id)
    {
      "errors": [
          {
              detail: "No MarketVendor with market_id=#{market_id} AND vendor_id=#{vendor_id} exists"
          }
        ]
      }
  end
end