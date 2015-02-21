require 'rails_helper'

describe 'Rating' do
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username: 'test_user', password: 'Passw0rd')
  end

  describe 'New Rating' do
    let!(:brewery) { FactoryGirl.create :brewery, name: 'Koff' }
    let!(:beer1) { FactoryGirl.create :beer, name: 'Iso 3', brewery: brewery }
    let!(:beer2) { FactoryGirl.create :beer, name: 'Karhu', brewery: brewery }

    it 'when given, is registered to the beer and user who is signed in' do
      visit new_rating_path
      select('Iso 3', from: 'rating[beer_id]')
      fill_in('rating[score]', with: '15')
      expect { click_button 'Create Rating' }.to change { Rating.count }.from(0).to(1)

      expect(user.ratings.count).to eq(1)
      expect(beer1.ratings.count).to eq(1)
      expect(beer1.average_rating).to eq(15.0)
    end
  end

  describe 'Empty rating statistics page' do
    it 'displays message if no ratings exist' do
      visit ratings_path
      expect(page).to have_content 'No ratings exist'
    end
  end

  describe 'Populated rating statistics page' do
    before :each do
      create_breweries
      create_styles
      create_beers
      create_ratings
    end

    it 'should list best beers' do
      best_beer = @beers.last
      expect(best_beer).to eq(Beer.top(1).first)

      visit ratings_path
      expect(page).to have_content 'Best beers'
      expect(page).to have_content "#{best_beer.name}"
      expect(page).to have_content "#{best_beer.average_rating}"
    end

    it 'should list best breweries' do
      best_brewery = @breweries.last
      expect(best_brewery).to eq(Brewery.top(1).first)

      visit ratings_path
      expect(page).to have_content 'Best breweries'
      expect(page).to have_content "#{best_brewery.name}"
      expect(page).to have_content "#{best_brewery.average_rating}"
    end
  end
end

def create_breweries
  breweries = %w(Koff BrewDog Sinebrychoff)
  year = 1896
  breweries.each do |brewery_name|
    FactoryGirl.create(:brewery, name: brewery_name, year: year += 1, active: true)
  end

  @breweries = Brewery.all
end

def create_styles
  @styles = %w(Lager IPA Porter)
  @styles.each do |style_name|
    FactoryGirl.create(:style, name: style_name, description: "Description for #{style_name}")
  end
end

def create_beers
  FactoryGirl.create(:beer, name: 'Koff III',
                            brewery: Brewery.find_by(name: 'Koff'),
                            style: Style.find_by(name: 'Lager'))
  FactoryGirl.create(:beer, name: 'Punk IPA',
                            brewery: Brewery.find_by(name: 'BrewDog'),
                            style: Style.find_by(name: 'IPA'))
  FactoryGirl.create(:beer, name: 'Porter',
                            brewery: Brewery.find_by(name: 'Sinebrychoff'),
                            style: Style.find_by(name: 'Porter'))

  @beers = Beer.all
end

def create_ratings
  score = 10
  @beers.each do |beer|
    FactoryGirl.create(:rating, score: score, beer: beer, user: user)
    score += 10
  end
end
