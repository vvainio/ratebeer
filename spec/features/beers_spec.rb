require 'rails_helper'

describe 'New Beer page' do
  let!(:style) { FactoryGirl.create :style, name: 'Lager' }
  let!(:brewery) { FactoryGirl.create :brewery, name: 'Koff' }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username: 'test_user', password: 'Passw0rd')
  end

  it 'creates new beer with valid name and style' do
    visit new_beer_path
    fill_in('beer_name', with: 'Karhu III')
    select('Lager', from: 'beer[style_id]')
    expect { click_button 'Create Beer' }.to change { Beer.count }.from(0).to(1)
  end

  it 'should not create beer with invalid name' do
    visit new_beer_path
    fill_in('beer_name', with: ' ')
    click_button 'Create Beer'
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end
