require 'rails_helper'

describe 'Rating' do
  let!(:brewery) { FactoryGirl.create :brewery, name: 'Koff' }
  let!(:beer1) { FactoryGirl.create :beer, name: 'Iso 3', brewery: brewery }
  let!(:beer2) { FactoryGirl.create :beer, name: 'Karhu', brewery: brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username: 'test_user', password: 'Passw0rd')
  end

  it 'when given, is registered to the beer and user who is signed in' do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')
    expect { click_button 'Create Rating' }.to change { Rating.count }.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe 'Ratings page' do
    it 'displays message if no ratings exist' do
      visit ratings_path
      expect(page).to have_content 'No ratings exist'
    end

    it 'should list the number of ratings' do
      beer = FactoryGirl.create(:beer, brewery: brewery)
      FactoryGirl.create(:rating, score: 20, beer: beer, user: user)

      visit ratings_path
      expect(page).to have_content 'Number of ratings: 1'
      expect(page).to have_content "#{beer.name}"
      expect(page).to have_content "#{beer.ratings.first.score}"
      expect(page).to have_content "#{beer.ratings.first.user.username}"
    end
  end
end
