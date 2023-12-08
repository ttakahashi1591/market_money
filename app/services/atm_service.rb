class AtmService 
  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def conn
    Faraday.new(url: "https://api.tomtom.com") do |faraday|
      faraday.params["API Key"] = Rails.application.credentials.tomtom[:key]
    end
  end

  def get_url(url)
    conn.get(url)
  end

  def get_atm_list  
    json_parse(get_url("/search/2/categorySearch/ATM.json?lat=#{@lat}&lon=#{@lon}&categorySet=7397&view=Unified&relatedPois=child&key=#{Rails.application.credentials.tomtom[:key]}"))
  end
end