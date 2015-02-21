require 'rails_helper'

describe Style do
  it 'is saved with a style and description' do
    style = Style.create name: 'Lager', description: 'Lager is a style'

    expect(style).to be_valid
    expect(Style.count).to eq(1)
    expect(style.name).to eq('Lager')
    expect(style.description).to eq('Lager is a style')
  end

  it 'is not saved if it has no name' do
    style = Style.create description: 'Lager is a beer'

    expect(style).not_to be_valid
    expect(Style.count).to eq(0)
  end

  describe 'with beers and ratings' do
    let!(:user1) { FactoryGirl.create :user, username: 'User 1' }
    let!(:user2) { FactoryGirl.create :user, username: 'User 2' }
    let!(:style1) { FactoryGirl.create :style, name: 'Lager' }
    let!(:style2) { FactoryGirl.create :style, name: 'IPA' }
    let!(:beer1) { FactoryGirl.create :beer, style: style1 }
    let!(:beer2) { FactoryGirl.create :beer, style: style2 }

    it 'top list has correct results' do
      FactoryGirl.create(:rating, score: 10, beer: beer1, user: user1)
      FactoryGirl.create(:rating, score: 20, beer: beer1, user: user2)

      FactoryGirl.create(:rating, score: 20, beer: beer2, user: user1)
      FactoryGirl.create(:rating, score: 30, beer: beer2, user: user2)

      top_styles = Style.top(2)

      expect(top_styles.first).to eq(style2)
      expect(top_styles.first.average_rating).to eq(25)

      expect(top_styles.last).to eq(style1)
      expect(top_styles.last.average_rating).to eq(15)
    end
  end
end
