class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :description, presence: true

  def self.top(n)
    Style.all.sort_by { |s| -(s.average_rating || 0) }.take(n)
  end

  def to_s
    "#{name}"
  end
end
