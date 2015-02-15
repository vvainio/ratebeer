require 'rails_helper'

describe Beer do
  it 'is saved with a name and style' do
    style = Style.create name: 'Lager', description: 'Lager is a beer'
    beer = Beer.create name: 'Sample Beer', style: style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
    expect(beer.name).to eq('Sample Beer')
    expect(beer.style.name).to eq('Lager')
    expect(beer.style.description).to eq('Lager is a beer')
  end

  it 'is not saved if it has no name' do
    style = Style.create name: 'Lager', description: 'Lager is a beer'
    beer = Beer.create style: style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it 'is not saved if it has no style' do
    beer = Beer.create name: 'Sample Beer'

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
