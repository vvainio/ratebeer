require 'rails_helper'

describe 'BeermappingApi' do
  before :each do
    Rails.cache.clear
  end

  it 'When HTTP GET returns zero entries, result is parsed and returned' do
    canned_answer = <<-END_OF_STRING
    <?xml version="1.0" encoding="UTF-8"?><bmp-locations><location><id nil="true"/><name nil="true"/><status nil="true"/><reviewlink nil="true"/><proxylink nil="true"/><blogmap nil="true"/><street nil="true"/><city nil="true"/><state nil="true"/><zip nil="true"/><country nil="true"/><phone nil="true"/><overall nil="true"/><imagecount nil="true"/></location></bmp-locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/)
      .to_return(body: canned_answer, headers: { 'Content-Type': 'text/xml' })

    places = BeermappingApi.places_in('espoo')

    expect(places.size).to eq(0)
  end

  it 'When HTTP GET returns one entry, it is parsed and returned' do
    canned_answer = <<-END_OF_STRING
    <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/)
      .to_return(body: canned_answer, headers: { 'Content-Type': 'text/xml' })

    places = BeermappingApi.places_in('espoo')

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq('Gallows Bird')
    expect(place.street).to eq('Merituulentie 30')
  end

  it 'When HTTP GET returns multiple entries, they are parsed and returned' do
    canned_answer = <<-END_OF_STRING
    <?xml version="1.0" encoding="UTF-8"?><bmp-locations><location type="array"><location><id>6742</id><name>Pullman Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=6742</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6742&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6742&amp;d=1&amp;type=norm</blogmap><street>Kaivokatu 1</street><city>Helsinki</city><state nil="true"/><zip>00100</zip><country>Finland</country><phone>+358 9 0307 22</phone><overall>72.500025</overall><imagecount>0</imagecount></location><location><id>6743</id><name>Belge</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=6743</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6743&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6743&amp;d=1&amp;type=norm</blogmap><street>Kluuvikatu 5</street><city>Helsinki</city><state nil="true"/><zip>00100</zip><country>Finland</country><phone>+358 10 766 35</phone><overall>67.499925</overall><imagecount>1</imagecount></location></location></bmp-locations>
    END_OF_STRING

    stub_request(:get, /.*espoo/)
      .to_return(body: canned_answer, headers: { 'Content-Type': 'text/xml' })

    places = BeermappingApi.places_in('espoo')

    expect(places.size).to eq(2)

    place = places.first
    expect(place.name).to eq('Pullman Bar')
    expect(place.street).to eq('Kaivokatu 1')

    place2 = places.last
    expect(place2.name).to eq('Belge')
    expect(place2.street).to eq('Kluuvikatu 5')
  end

  describe 'in case of cache miss' do
    before :each do
      Rails.cache.clear
    end

    it 'When HTTP GET returns one entry, it is parsed and returned' do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*tampere/)
        .to_return(body: canned_answer, headers: { 'Content-Type': 'text/xml' })

      places = BeermappingApi.places_in('tampere')

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq('Rautatienkatu 24')
    end
  end

  describe 'in case of cache hit' do
    it 'When one entry in cache, it is returned' do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*tampere/)
        .to_return(body: canned_answer, headers: { 'Content-Type': 'text/xml' })

      # Ensure that data is found in cache
      BeermappingApi.places_in('tampere')

      places = BeermappingApi.places_in('tampere')

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq('Rautatienkatu 24')
    end
  end
end
