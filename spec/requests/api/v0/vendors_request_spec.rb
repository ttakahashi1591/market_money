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

  describe "create a vendor" do
    it "can create a new item" do
      vendor_id = create(:vendor).id

      vendor_params = ({
                        name: "Happy Honey",
                        description: "We get our honey from happy bees",
                        contact_name: "Horace",
                        contact_phone: "1-276-593-3530",
                        credit_accepted: false
                      })
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to have_http_status(201)
      expect(response).to be_successful

      created_vendor = Vendor.last

      expect(created_vendor.name).to eq(vendor_params[:name])
      expect(created_vendor.description).to eq(vendor_params[:description])
      expect(created_vendor.contact_name).to eq(vendor_params[:contact_name])
      expect(created_vendor.contact_phone).to eq(vendor_params[:contact_phone])
      expect(created_vendor.credit_accepted).to eq(vendor_params[:credit_accepted])      
    end

    it "sends an error if a new vendor request is sent through missing any of the following attribures: name, description, contact_name, contact_phone, and credit_accepted" do
      vendor_id = create(:vendor).id

      vendor_params = ({
                        name: "Happy Honey",
                        description: "We get our honey from happy bees",
                        contact_name: "Horace",
                        contact_phone: "1-276-593-3530",
                      })
      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      created_vendor = Vendor.last
            
      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("400")
      expect(data[:errors].first[:title]).to eq("Credit accepted is reserved, Credit accepted is not included in the list")
    end
  end

  describe "delete a vendor" do
    it "can delete an existing vendor" do
      Vendor.destroy_all
      
      vendor = create(:vendor)

      expect(Vendor.count).to eq(1)

      delete "/api/v0/vendors/#{vendor.id}"

      expect(response).to be_successful
      expect(response).to have_http_status(204)
      expect(Vendor.count).to eq(0)
    end
  end

  describe "update a vendor" do
    it "can update one or more attributes of a specific vendor" do
      vendor = create(:vendor)

      body = ({
                "name": "Hungry Honey",
                "description": "We get our honey from hungry bees",
                "contact_name": "James",
                "credit_accepted": true,
              })
      headers = { "CONTENT_TYPE" => "application/json" }
      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: body)
      
      updated_vendor = Vendor.last
      
      expect(response).to be_successful
      expect(response).to have_http_status(200)
      
      expect(updated_vendor.name).to eq("Hungry Honey")
      expect(updated_vendor.description).to eq("We get our honey from hungry bees")
      expect(updated_vendor.contact_name).to eq("James")
      expect(updated_vendor.credit_accepted).to eq(true)
      
      body = ({
        "name": "No More Honey",
        "description": "We dont have bees to get honey from",
        "contact_name": "Not Available"
      })
      headers = { "CONTENT_TYPE" => "application/json" }
      
      patch "/api/v0/vendors/#{updated_vendor.id}", headers: headers, params: JSON.generate(vendor: body)

      updated_vendor = Vendor.last
            
      expect(response).to be_successful
      expect(response).to have_http_status(200)

      expect(updated_vendor.name).to eq("No More Honey")
      expect(updated_vendor.description).to eq("We dont have bees to get honey from")
      expect(updated_vendor.contact_name).to eq("Not Available")
      expect(updated_vendor.credit_accepted).to eq(true)
    end

    it "sends an error if an invalid vendor id is entered" do
      body = ({
                "name": "Hungry Honey",
                "description": "We get our honey from hungry bees",
                "contact_name": "James",
                "credit_accepted": true
              })
      headers = { "CONTENT_TYPE" => "application/json" }

      patch "/api/v0/vendors/15", headers: headers, params: JSON.generate(vendor: body)
      
      expect(response).to_not be_successful
      expect(response).to have_http_status(404)
      
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Vendor with 'id'=15")
    end  

    it "sends an error if an attribute if an empty attribute is entered" do
      vendor = create(:vendor)

      body = ({
                "name": "No More Honey",
                "description": "We dont have bees to get honey from",
                "contact_name": "",
                "credit_accepted": true
      })
      
      headers = { "CONTENT_TYPE" => "application/json" }
      
      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: body)
            
      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("400")
      expect(data[:errors].first[:title]).to eq("Contact name can't be blank")
    end

    it "sends an error if an attribute if an empty attribute is entered" do
      vendor = create(:vendor)

      body = ({
                "name": "No More Honey",
                "description": "We dont have bees to get honey from",
                "contact_name": "James",
                "credit_accepted": nil
      })

      headers = { "CONTENT_TYPE" => "application/json" }
      
      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor: body)
            
      expect(response).to_not be_successful
      expect(response).to have_http_status(400)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:errors]).to be_an(Array)
      expect(data[:errors].first[:status]).to eq("400")
      expect(data[:errors].first[:title]).to eq("Credit accepted is reserved, Credit accepted is not included in the list")
    end
  end
end
