class Style < ActiveRecord::Base
  has_many :beers
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :description, presence: true

  def self.top(n)
    Style.all.sort_by { |s| -(s.ratings.average(:score) || 0) }.take(n)
  end

  # TODO: Figure out why undefined method `average_rating' is thrown unless
  # the method is defined here
  def average_rating
    ratings.average(:score).round(1)
  end

  def to_s
    "#{name}"
  end
end
