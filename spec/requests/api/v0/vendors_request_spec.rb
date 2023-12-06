require 'rails_helper'

RSpec.describe "Vendors API Endpoints", type: :request do
  describe "get one vendor" do
    it "sends one specific vendor" do
      vendor_id = create(:vendor).id

      get api_v0_vendor_path(vendor_id)

      expect(response).to be_successful

      vendor = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_a(String)

      expect(vendor).to have_key(:type)
      expect(vendor[:type]).to eq("vendor")

      expect(vendor).to have_key(:attributes)
      expect(vendor[:attributes]).to be_a(Hash)
      expect(vendor[:attributes][:description]).to be_a(String)
      expect(vendor[:attributes][:contact_name]).to be_a(String)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)
      expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    end

    it "sends an error if an invalid vendor id is entered" do
      get "/api/v0/vendors/15"

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
          
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=15")
    end
  end
end
