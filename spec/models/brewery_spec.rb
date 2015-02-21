require 'rails_helper'

describe Brewery do
  it 'has the name and year set correctly and is saved to database' do
    brewery = Brewery.create name: 'Schlenkerla', year: 1674

    expect(brewery.name).to eq('Schlenkerla')
    expect(brewery.year).to eq(1674)
    expect(brewery).to be_valid
  end

  it 'without a name is not valid' do
    brewery = Brewery.create year: 1674

    expect(brewery).not_to be_valid
  end

  describe 'with ratings' do
    let!(:user) { FactoryGirl.create :user }
    let!(:brewery) { FactoryGirl.create :brewery, name: 'Brewery' }

    it 'has the correct average' do
      create_beer_to_brewery_with_rating(brewery, 5, user)
      create_beer_to_brewery_with_rating(brewery, 10, user)
      create_beer_to_brewery_with_rating(brewery, 15, user)

      expect(brewery.average_rating).to eq(10)
    end
  end

  describe 'multiple breweries' do
    let!(:user) { FactoryGirl.create :user }
    let!(:brewery1) { FactoryGirl.create :brewery, name: 'Brewery 1' }
    let!(:brewery2) { FactoryGirl.create :brewery, name: 'Brewery 2' }

    it 'top list has correct results' do
      create_beer_to_brewery_with_rating(brewery1, 5, user)
      create_beer_to_brewery_with_rating(brewery1, 10, user)
      create_beer_to_brewery_with_rating(brewery1, 15, user) # avg 10

      create_beer_to_brewery_with_rating(brewery2, 30, user)
      create_beer_to_brewery_with_rating(brewery2, 30, user) # avg 30

      top_breweries = Brewery.top(2)
      expect(top_breweries.first).to eq(brewery2)
      expect(top_breweries.first.average_rating).to eq(30)

      expect(top_breweries.last).to eq(brewery1)
      expect(top_breweries.last.average_rating).to eq(10)
    end
  end
end
