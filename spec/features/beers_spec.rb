require 'rails_helper'

describe 'New Beer page' do
  let!(:brewery) { FactoryGirl.create :brewery, name: 'Koff' }

  it 'creates new beer with valid name' do
    visit new_beer_path
    fill_in('beer_name', with: 'Karhu III')
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
