require 'rails_helper'

describe 'Breweries page' do
  it 'should not have any before been created' do
    visit breweries_path
    expect(page).to have_content 'Breweries'
    expect(page).to have_content 'No breweries exist'
  end

  describe 'when breweries exists' do
    before :each do
      @breweries = %w(Koff Karjala Schlenkerla)
      year = 1896
      @breweries.each do |brewery_name|
        FactoryGirl.create(:brewery, name: brewery_name, year: year += 1, active: true)
      end

      visit breweries_path
    end

    it 'lists the active breweries and their total number' do
      expect(page).to have_content "Number of active breweries: #{@breweries.count}"
      @breweries.each do |brewery_name|
        expect(page).to have_content brewery_name
      end
    end

    it 'lists the retired breweries and their total number' do
      FactoryGirl.create(:brewery, name: 'Inactive brewery', year: 1900, active: false)
      expect(page).to have_content 'Number of retired breweries: 1'
    end

    it 'allows user to navigate to page of a Brewery' do
      click_link 'Koff'

      expect(page).to have_content 'Koff'
      expect(page).to have_content 'Established in 1897'
    end
  end
end
