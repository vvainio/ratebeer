require 'rails_helper'

describe Beer do
  it 'is saved with a name and style' do
    beer = Beer.create name: 'Sample Beer', style: 'Lager'

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
    expect(beer.name).to eq('Sample Beer')
    expect(beer.style).to eq('Lager')
  end

  it 'is not saved if it has no name' do
    beer = Beer.create style: 'Lager'

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it 'is not saved if it has no style' do
    beer = Beer.create name: 'Sample Beer'

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
