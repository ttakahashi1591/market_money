require 'rails_helper'

describe "Makrets Search API" do
  describe "search for market" do 
    it "can retrieve one market by searching for one of the following parameters: city, state, or name" do
      create_list(:vendor, 15)

      market = Market.create!(name: "McClure, Lemke and Johnston", street: "172 Season Throughway", city: "North Malikshire", county: "Summer Village", state: "California", zip: "90505", lat: "63.271975188966366", lon: "-69.61687531973736")

      create_list(:market, 15)
      create_list(:market_vendor, 10)

      get "/api/v0/markets/search?city=North malikshire&state=california&name=Mcclure lemke Johnston"

      expect(response).to be_successful
      expect(response.status).to eq(200)
    
      expect(market[:id]).to be_a(Integer)
      expect(market[:name]).to eq("McClure, Lemke and Johnston")
      expect(market[:street]).to eq("172 Season Throughway")
      expect(market[:city]).to eq("North Malikshire")
      expect(market[:county]).to eq("Summer Village")
      expect(market[:state]).to eq("California")
      expect(market[:zip]).to eq("90505")
      expect(market[:lat]).to eq("63.271975188966366")
      expect(market[:lon]).to eq("-69.61687531973736")   
    end

    it "error invalid params (can't search city without state)" do
      create_list(:vendor, 20)

      market = Market.create!(name: "McClure, Lemke and Johnston", street: "172 Season Throughway", city: "North Malikshire", county: "Summer Village", state: "California", zip: "90505", lat: "63.271975188966366", lon: "-69.61687531973736")

      create_list(:market, 20)
      create_list(:market_vendor, 10)

      get "/api/v0/markets/search?city=north Malikshire&name=McClure lemke Johnston"

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
  
      error = JSON.parse(response.body, symbolize_names: true)[:errors]
      expect(error.first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
  
      get "/api/v0/markets/search?city=North malikshire"

      expect(response).to_not be_successful
      expect(response.status).to eq(422)
  
      error = JSON.parse(response.body, symbolize_names: true)[:errors]
      expect(error.first[:detail]).to eq("Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.")
    end
  end
end