require 'rails_helper'

describe Beer do
  it 'is saved with a name and style' do
    style = Style.create name: 'Lager', description: 'Lager is a beer'
    beer = Beer.create name: 'Sample Beer', style: style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
    expect(beer.name).to eq('Sample Beer')
    expect(beer.style.name).to eq('Lager')
    expect(beer.style.description).to eq('Lager is a beer')
  end

  it 'is not saved if it has no name' do
    style = Style.create name: 'Lager', description: 'Lager is a beer'
    beer = Beer.create style: style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it 'is not saved if it has no style' do
    beer = Beer.create name: 'Sample Beer'

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  describe 'with ratings' do
    let!(:user1) { FactoryGirl.create :user, username: 'User 1' }
    let!(:user2) { FactoryGirl.create :user, username: 'User 2' }
    let!(:beer1) { FactoryGirl.create :beer }
    let!(:beer2) { FactoryGirl.create :beer }

    it 'has the correct average' do
      best = create_beer_with_rating(50, user2)

      expect(Beer.top(1).first).to eq(best)
    end

    it 'top list has correct results' do
      FactoryGirl.create(:rating, score: 10, beer: beer1, user: user1)
      FactoryGirl.create(:rating, score: 20, beer: beer1, user: user2)

      FactoryGirl.create(:rating, score: 20, beer: beer2, user: user1)
      FactoryGirl.create(:rating, score: 30, beer: beer2, user: user2)

      top_beers = Beer.top(2)

      expect(top_beers.first).to eq(beer2)
      expect(top_beers.first.average_rating).to eq(25)

      expect(top_beers.last).to eq(beer1)
      expect(top_beers.last.average_rating).to eq(15)
    end
  end
end
