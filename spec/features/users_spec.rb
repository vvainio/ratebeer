require 'rails_helper'

describe 'User' do
  before :each do
    FactoryGirl.create :user
  end

  describe 'who has signed up' do
    it 'can signin with right credentials' do
      sign_in(username: 'test_user', password: 'Passw0rd')
      expect(page).to have_content 'Welcome back, test_user!'
    end

    it 'is redirected back to signin form if wrong credentials given' do
      sign_in(username: 'test_user', password: 'wrong')
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch!'
    end

    it 'when signed up with good credentials, is added to the system' do
      visit signup_path
      fill_in('user_username', with: 'test_user2')
      fill_in('user_password', with: 'Secret55')
      fill_in('user_password_confirmation', with: 'Secret55')

      expect { click_button('Create User') }.to change { User.count }.by(1)
    end
  end

  describe 'show page' do
    it 'should list only ratings made by user' do
      user = User.first
      user2 = User.create username: 'test_user2'
      beer = add_rating_by_user(user)
      add_rating_by_user(user2)

      visit user_path(user)
      expect(page).to have_content beer.name
      expect(page).to have_content user.username
      expect(page).to_not have_content user2.username
    end

    it 'should remove deleted rating from database' do
      sign_in(username: 'test_user', password: 'Passw0rd')
      user = User.first
      add_rating_by_user(user)

      visit user_path(user)
      expect { click_on('delete') }.to change { user.ratings.count }.from(1).to(0)
    end
  end
end

def add_rating_by_user(user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score: 10, beer: beer, user: user)
  beer
end

# to be included in simplecov
BeerClub
BeerClubsController
