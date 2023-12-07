require 'rails_helper'

RSpec.describe "MarketVendors API Endpoints", type: :request do
  describe "create a marketvendor" do
    it "can create a new marketvendor" do
      market = create(:market)
      vendor = create(:vendor)

      post "/api/v0/market_vendors", params: { market_vendor: market.id, vendor_id: vendor.id }

      expect(response).to be_successful
      expect(response).to have_http_status(201)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("")
    end
  end
end