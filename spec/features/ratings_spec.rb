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
end
