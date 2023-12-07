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

      expect(response).to be_successful
      expect(response).to have_http_status(201)

      data = JSON.parse(response.body, symbolize_names: true)

      created_market_vendor = data[:data][:attributes]
                      
      expect(created_market_vendor[:market_id]).to eq(market_vendor_params[:market_id])
      expect(created_market_vendor[:vendor_id]).to eq(market_vendor_params[:vendor_id])
    end

    it "sends an error if invalid market id is provided" do
      vendor = create(:vendor)

      market_vendor_params = {
                              market_id: 987654321,
                              vendor_id: vendor.id
                              }
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      created_market_vendor = MarketVendor.last

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Validation failed: Market must exist")
    end

    it "sends an error if invalid vendor id is provided" do
      market = create(:market)

      market_vendor_params = {
                              market_id: market.id,
                              vendor_id: 987654321
                              }
      headers = { "CONTENT_TYPE" => "application/json" }
      
      post "/api/v0/market_vendors", params: { market_vendor: { market_id: market.id, vendor_id: 987654321 } }

      expect(response).to_not be_successful
      expect(response).to have_http_status(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Validation failed: Vendor must exist")
    end

    it "sends an error if market vendor association already exists" do
      market = create(:market)
      vendor = create(:vendor)
      
      existing_market_vendor = create(:market_vendor, market: market, vendor: vendor)

      post "/api/v0/market_vendors", params: { market_vendor: { market_id: market.id, vendor_id: vendor.id } }

      expect(response).to_not be_successful
      expect(response).to have_http_status(422)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("422")
      expect(data[:errors].first[:title]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end

    it "sends an error if vendor id is missing" do
      market = create(:market)
      vendor = create(:vendor)
      
      post "/api/v0/market_vendors", params: { market_vendor: { market_id: market.id } }

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("400")
      expect(data[:errors].first[:title]).to eq("Validation failed: Vendor must exist, Vendor can't be blank")
    end

    it "sends an error if market id is missing" do
      market = create(:market)
      vendor = create(:vendor)
      
      post "/api/v0/market_vendors", params: { market_vendor: { vendor_id: vendor.id } }

      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("400")
      expect(data[:errors].first[:title]).to eq("Validation failed: Market must exist, Market can't be blank")
    end
  end

  describe "delete a marketvendor" do
    it "can delete an existing marketvendor" do
      market = create(:market)
      vendor = create(:vendor)
      create(:market_vendor, market: market, vendor: vendor)
      market_vendor_params = ({
        market_id: market.id,
        vendor_id: vendor.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      expect(MarketVendor.count).to eq(1)

      delete "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor: market_vendor_params)
      
      expect(response).to be_successful
      expect(response.status).to eq(204)
      expect(MarketVendor.count).to eq(0)
    end

    it "sends an error if market vendor association already exists" do
      market = create(:market)
      vendor = create(:vendor)
      
      market_vendor_params = ({
                      market_id: market.id,
                      vendor_id: vendor.id
                    })
      headers = {'CONTENT_TYPE' => 'application/json'}

      delete '/api/v0/market_vendors', headers: headers, params: JSON.generate(market_vendor: market_vendor_params)

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq('404')
      expect(data[:errors].first[:title]).to eq("Validation failed: Market vendor asociation between market with market_id=#{market.id} and vendor_id=#{vendor.id} already exists")
    end
  end
end