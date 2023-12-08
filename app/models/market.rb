class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  def self.search(params)
    Market.where("city ilike '%#{params[:city]}%' and state ilike '%#{params[:state]}%' and name ilike '%#{params[:name]}%'")
  end

  def self.nearest_atms(params)

  end
end