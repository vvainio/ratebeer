class BeermappingApi
  def self.place(id)
    Rails.cache.fetch(id) { fetch_place(id) }
  end

  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city) { fetch_places_in(city) }
  end

  private

  def self.fetch_place(id)
    params = "locquery/#{apikey}/#{id}"
    data = parse_response(request_with(params))
  end

  def self.fetch_places_in(city)
    params = "loccity/#{apikey}/#{ERB::Util.url_encode(city)}"
    places = parse_response(request_with(params))
    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.request_with(params)
    response = HTTParty.get "#{baseurl}#{params}"
    response.parsed_response['bmp_locations']['location']
  end

  def self.parse_response(data)
    data.is_a?(Hash) && data['id'].nil? ? [] : data
  end

  def self.baseurl
    # Cached api 'http://stark-oasis-9187.herokuapp.com/api/'
    'http://beermapping.com/webservice/'
  end

  def self.apikey
    Rails.application.secrets.beermapping_apikey ||
      ENV['BEERMAPPING_APIKEY'] ||
      (fail 'BeerMapping APIKEY is not defined')
  end
end
