require 'rails_helper'

RSpec.describe "Markets API Endpoints", type: :request do
  describe "get all markets" do
    it "sends a list of all markets" do
      create_list(:market, 5)

      get api_v0_markets_path

      expect(response).to be_successful

      markets = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(markets.count).to eq(5)
      
      markets.each do |market|
        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)

        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market")

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a(Hash)
        expect(market[:attributes][:name]).to be_a(String)
        expect(market[:attributes][:street]).to be_a(String)
        expect(market[:attributes][:city]).to be_a(String)
        expect(market[:attributes][:county]).to be_a(String)
        expect(market[:attributes][:state]).to be_a(String)
        expect(market[:attributes][:zip]).to be_a(String)
        expect(market[:attributes][:lat]).to be_a(String)
        expect(market[:attributes][:lon]).to be_a(String)
        expect(market[:attributes][:vendor_count]).to be_an(Integer)

        expect(market).to have_key(:relationships)
        expect(market[:relationships]).to be_a(Hash)
        expect(market[:relationships][:vendors]).to be_a(Hash)
        expect(market[:relationships][:vendors][:data]).to be_an(Array)
      end
    end

    describe "get one market" do
      it "sends one specific market" do
        market_id = create(:market).id

        get api_v0_market_path(market_id)

        expect(response).to be_successful

        market = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(market).to have_key(:id)
        expect(market[:id]).to be_a(String)

        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market")

        expect(market).to have_key(:attributes)
        expect(market[:attributes]).to be_a(Hash)
        expect(market[:attributes][:name]).to be_a(String)
        expect(market[:attributes][:street]).to be_a(String)
        expect(market[:attributes][:city]).to be_a(String)
        expect(market[:attributes][:county]).to be_a(String)
        expect(market[:attributes][:state]).to be_a(String)
        expect(market[:attributes][:zip]).to be_a(String)
        expect(market[:attributes][:lat]).to be_a(String)
        expect(market[:attributes][:lon]).to be_a(String)
        expect(market[:attributes][:vendor_count]).to be_an(Integer)

        expect(market).to have_key(:relationships)
        expect(market[:relationships]).to be_a(Hash)
        expect(market[:relationships][:vendors]).to be_a(Hash)
        expect(market[:relationships][:vendors][:data]).to be_an(Array)
      end
    end

    it "sends an error if an invalid market id is entered" do
      get "/api/v0/markets/15"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
      
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Market with 'id'=15")
    end
  end
end