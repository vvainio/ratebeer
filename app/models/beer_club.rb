class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true
  validates :founded, numericality: { greater_than_or_equal_to: 1042,
                                      less_than_or_equal_to: proc { Time.now.year },
                                      only_integer: true }
  validates :city, presence: true

  def to_s
    "#{name} (#{city} - #{founded})"
  end
end
