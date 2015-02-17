class AddActivityToBrewery < ActiveRecord::Migration
  def change
    add_column :breweries, :active, :boolean

    Brewery.all.each do |b|
      b.active = true
      b.save
    end
  end
end
