require 'rails_helper'

describe 'ngbeerlist page' do
  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: 'Koff')
    @brewery2 = FactoryGirl.create(:brewery, name: 'Schlenkerla')
    @brewery3 = FactoryGirl.create(:brewery, name: 'Ayinger')
    @style1 = Style.create name: 'Lager', description: 'Description for lager'
    @style2 = Style.create name: 'Rauchbier', description: 'Description for rauchbier'
    @style3 = Style.create name: 'Weizen', description: 'Description for weizen'
    @beer1 = FactoryGirl.create(:beer, name: 'Nikolai', brewery: @brewery1, style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: 'Fastenbier', brewery: @brewery2, style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: 'Lechte Weisse', brewery: @brewery3, style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it 'shows one known beer', js: true do
    visit ngbeerlist_path
    find('table').find('tbody > tr:nth-child(1)')
    expect(page).to have_content 'Nikolai'
  end

  it 'has beers sorted alphabetically by name', js: true do
    visit ngbeerlist_path
    first = find('table').find('tbody > tr:nth-child(1)')
    last = find('table').find('tbody > tr:nth-child(3)')
    expect(first).to have_content 'Fastenbier'
    expect(last).to have_content 'Nikolai'
  end

  it 'has beers sorted alphabetically by style', js: true do
    visit ngbeerlist_path
    find('table > thead > tr > th:nth-child(2) > a').click
    first = find('table').find('tbody > tr:nth-child(1)')
    last = find('table').find('tbody > tr:nth-child(3)')
    expect(first).to have_content 'Lager'
    expect(last).to have_content 'Weizen'
  end

  it 'has beers sorted alphabetically by brewery', js: true do
    visit ngbeerlist_path
    find('table > thead > tr > th:nth-child(3) > a').click
    first = find('table').find('tbody > tr:nth-child(1)')
    last = find('table').find('tbody > tr:nth-child(3)')
    expect(first).to have_content 'Ayinger'
    expect(last).to have_content 'Schlenkerla'
  end
end
