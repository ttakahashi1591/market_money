require 'rails_helper'

RSpec.describe "MarketVendors API Endpoints", type: :request do
  describe "create a marketvendor" do
    it "can create a new marketvendor" do
      market = create(:market)
      vendor = create(:vendor)

      market_vendor_params = {
                              market_id: market.id,
                              vendor_id: vendor.id
                              }
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to have_http_status(201)
      expect(response).to be_successful

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("Successfully added vendor to market") 

      created_market_vendor = MarketVendor.last

      expect(created_market_vendor.market_id).to eq(market_vendor_params[:market_id])
      expect(created_market_vendor.vendor_id).to eq(market_vendor_params[:vendor_id])
    end

    it "sends an error if invalid market id is provided" do
      vendor = create(:vendor)

      market_vendor_params = {
                              market_id: 987654321,
                              vendor_id: vendor.id
                              }
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Market must exist")
    end

    xit "sends an error if invalid vendor id is provided" do
      post "/api/v0/market_vendors", params: { market_vendor: { market_id: market.id, vendor_id: 987654321 } }

      expect(response).to have_http_status(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Vendor must exist")
    end

    xit "sends an error if market vendor association already exists" do
      existing_market_vendor = create(:market_vendor, market: market, vendor: vendor)

      post "/api/v0/market_vendors", params: { market_vendor: { market_id: market.id, vendor_id: vendor.id } }

      expect(response).to have_http_status(422)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to eq("Validation failed: Market vendor association already exists")
    end

    xit "sends an error if market id or vendor id is missing" do
      post "/api/v0/market_vendors", params: { market_vendor: { market_id: market.id } }

      expect(response).to have_http_status(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:detail]).to include("Vendor can't be blank")
    end
  end
end