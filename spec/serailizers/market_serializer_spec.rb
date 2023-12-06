require 'rails_helper'

RSpec.describe MarketSerializer, type: :request do
  describe "Market Serializer" do
    it "serailizes data to JSON" do
      create_list(:market, 5)

      get api_v0_markets_path

      expect(response).to be_successful

      data = JSON.parse(response.body)
      
      market = data["data"][0]

      expect(market).to have_key("id")
      expect(market["id"]).to be_a(String)

      expect(market).to have_key("type")
      expect(market["type"]).to eq("market")

      expect(market).to have_key("attributes")
      expect(market["attributes"]).to be_a(Hash)
      expect(market["attributes"]["name"]).to be_a(String)
      expect(market["attributes"]["street"]).to be_a(String)
      expect(market["attributes"]["city"]).to be_a(String)
      expect(market["attributes"]["county"]).to be_a(String)
      expect(market["attributes"]["state"]).to be_a(String)
      expect(market["attributes"]["zip"]).to be_a(String)
      expect(market["attributes"]["lat"]).to be_a(String)
      expect(market["attributes"]["lon"]).to be_a(String)
      expect(market["attributes"]["vendor_count"]).to be_an(Integer)

      expect(market).to have_key("relationships")
      expect(market["relationships"]).to be_a(Hash)
      expect(market["relationships"]["vendors"]).to be_a(Hash)
      expect(market["relationships"]["vendors"]["data"]).to be_an(Array)
    end
  end
end