require 'rails_helper'

describe 'Places' do
  it 'if nothing is returned by the API, a notification is shown on the page' do
    allow(BeermappingApi).to receive(:places_in).with('Helsinki').and_return(
      []
    )
    search_by_city('Helsinki')
    expect(page).to have_content 'No locations in Helsinki'
  end

  it 'if one is returned by the API, it is shown on the page' do
    allow(BeermappingApi).to receive(:places_in).with('Helsinki').and_return(
      [Place.new(name: 'Place 1', id: 1)]
    )
    search_by_city('Helsinki')
    expect(page).to have_content 'Place 1'
  end

  it 'if multiple are returned by the API, they are shown on the page' do
    allow(BeermappingApi).to receive(:places_in).with('Helsinki').and_return(
      [Place.new(name: 'Place 1', id: 1), Place.new(name: 'Place 2', id: 2)]
    )
    search_by_city('Helsinki')
    expect(page).to have_content 'Place 1'
    expect(page).to have_content 'Place 2'
  end
end

def search_by_city(city)
  visit places_path
  fill_in('city', with: city)
  click_button 'Search'
end
