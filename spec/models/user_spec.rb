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
      beer = create_beer_with_rating(10, user)

      expect(user.favorite_beer).to eq(beer)
    end

    it 'is the one with highest rating if several rated' do
      create_beers_with_ratings(10, 20, 15, 7, 9, user)
      best = create_beer_with_rating(25, user)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe 'favorite style' do
    let(:user) { FactoryGirl.create(:user) }

    it 'has method for determining one' do
      expect(user).to respond_to :favorite_style
    end

    it 'without ratings does not have one' do
      expect(user.favorite_style).to eq(nil)
    end

    it 'is the only rated if only one rating' do
      create_beer_with_style_and_rating('Lager', 10, user)
      expect(user.favorite_style.name).to eq('Lager')
    end

    it 'is the one with highest avg rating if several rated' do
      create_beer_with_style_and_rating('IPA', 5, user)
      create_beer_with_style_and_rating('IPA', 10, user) # avg 7.5
      create_beer_with_style_and_rating('Porter', 20, user) # avg 20
      create_beer_with_style_and_rating('Lager', 20, user)
      create_beer_with_style_and_rating('Lager', 40, user) # avg 30
      create_beer_with_style_and_rating('lowalcohol', 25, user) # avg 25

      expect(user.favorite_style.name).to eq('Lager')
    end
  end

  describe 'favorite brewery' do
    let(:user) { FactoryGirl.create(:user) }

    it 'has method for determining one' do
      expect(user).to respond_to :favorite_brewery
    end

    it 'without ratings does not have one' do
      expect(user.favorite_brewery).to eq(nil)
    end

    it 'is the only rated if only one rating' do
      brewery = FactoryGirl.create(:brewery, name: 'Sinebrychoff')
      create_beer_to_brewery_with_rating(brewery, 10, user)
      expect(user.favorite_brewery.name).to eq('Sinebrychoff')
    end

    it 'is the one with highest avg rating if several rated' do
      brewery1 = FactoryGirl.create(:brewery, name: 'BrewDog')
      brewery2 = FactoryGirl.create(:brewery, name: 'Sinebrychoff')
      brewery3 = FactoryGirl.create(:brewery, name: 'Weihenstephaner')

      create_beer_to_brewery_with_rating(brewery1, 15, user) # BrewDog avg 15
      create_beer_to_brewery_with_rating(brewery2, 5, user)
      create_beer_to_brewery_with_rating(brewery2, 10, user)
      create_beer_to_brewery_with_rating(brewery2, 15, user) # Sinebrychoff avg 10
      create_beer_to_brewery_with_rating(brewery3, 5, user) # Weihenstephaner avg 5

      expect(user.favorite_brewery).to eq(brewery1)
    end
  end
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

def create_beer_with_rating(score, user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score: score, beer: beer, user: user)
  beer
end

def create_beer_with_style_and_rating(style, score, user)
  style = FactoryGirl.create(:style)
  beer = FactoryGirl.create(:beer, style: style)
  FactoryGirl.create(:rating, score: score, beer: beer, user: user)
  beer
end

def create_beer_to_brewery_with_rating(brewery, score, user)
  beer = FactoryGirl.create(:beer, brewery: brewery)
  FactoryGirl.create(:rating, score: score, beer: beer, user: user)
  beer
end
