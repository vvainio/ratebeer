require 'rails_helper'

describe User do
  it 'has the username set correctly' do
    user = User.new username: 'test_user'

    expect(user.username).to eq('test_user')
  end

  it 'is not saved without a password' do
    user = User.create username: 'test_user'

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it 'is not saved with a password containing only alphabets' do
    user = User.create username: 'test_user', password: 'password', password_confirmation: 'password'

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it 'is not saved with too short a password' do
    user = User.create username: 'test_user', password: 'Ab1', password_confirmation: 'Ab1'

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe 'with a proper password' do
    let(:user) { FactoryGirl.create(:user) }

    it 'is saved' do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it 'and with two ratings, has the correct average rating' do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe 'favorite beer' do
    let(:user) { FactoryGirl.create(:user) }

    it 'has method for determining one' do
      expect(user).to respond_to :favorite_beer
    end

    it 'without ratings does not have one' do
      expect(user.favorite_beer).to eq(nil)
    end

    it 'is the only rated if only one rating' do
      beer = FactoryGirl.create(:beer)

      FactoryGirl.create(:rating, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it 'is the one with highest rating if several rated' do
      beer1 = FactoryGirl.create(:beer)
      beer2 = FactoryGirl.create(:beer)
      beer3 = FactoryGirl.create(:beer)

      FactoryGirl.create(:rating, beer: beer1, user: user)
      FactoryGirl.create(:rating, score: 25,  beer: beer2, user: user)
      FactoryGirl.create(:rating, score: 9, beer: beer3, user: user)

      expect(user.favorite_beer).to eq(beer2)
    end
  end
end
