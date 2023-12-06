RSpec.describe VendorSerializer, type: :request do
  describe "Vendor Serializer" do
    it "serailizes data to JSON" do
      market = create(:market)
      vendor_1 = create(:vendor)
      vendor_2 = create(:vendor)
      vendor_3 = create(:vendor)

      create(:market_vendor, market: market, vendor: vendor_1)
      create(:market_vendor, market: market, vendor: vendor_2)
      create(:market_vendor, market: market, vendor: vendor_3)

      market_id = market.id

      get api_v0_market_vendors_path(market_id)

      expect(response).to be_successful

      market_vendors = JSON.parse(response.body)["data"]

      expect(market_vendors.count).to eq(3)

      market_vendors.each do |vendor|
        expect(vendor).to have_key("id")
        expect(vendor["id"]).to be_a(String)

        expect(vendor).to have_key("type")
        expect(vendor["type"]).to eq("vendor")

        expect(vendor).to have_key("attributes")
        expect(vendor["attributes"]).to be_a(Hash)

        expect(vendor["attributes"]).to have_key("name")
        expect(vendor["attributes"]["name"]).to be_a(String)

        expect(vendor["attributes"]).to have_key("description")
        expect(vendor["attributes"]["description"]).to be_a(String)

        expect(vendor["attributes"]).to have_key("contact_name")
        expect(vendor["attributes"]["contact_name"]).to be_a(String)

        expect(vendor["attributes"]).to have_key("contact_phone")
        expect(vendor["attributes"]["contact_phone"]).to be_a(String)
        expect(vendor["attributes"]).to have_key("credit_accepted")
        expect(vendor["attributes"]["credit_accepted"]).to be_a(TrueClass).or be_a(FalseClass)
      end
    end
  end 
end