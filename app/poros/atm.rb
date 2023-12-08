class Atm
  attr_reader :id, 
              :name, 
              :address, 
              :lat, 
              :lon, 
              :distance
              
  def initialize(data)
    @id = nil
    @name = data[:poi][:name]
    @address = data[:address][:freeformAddress]
    @lat = data[:position][:lat]
    @lon = data[:position][:lon]
    @distance = converted_distance(data[:dist])
  end

  def converted_distance(dist)
    dist * 0.00061975844694
  end
end