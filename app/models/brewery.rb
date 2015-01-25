class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
end
