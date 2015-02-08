class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 15 }
  validates :password, length: { minimum: 4 },
                       format: { with: /(?=.*[A-Z])(?=.*\d).+/,
                                 message: 'must contain at least one capital letter (A-Z) and one digit (0-9)'}

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by(&:score).last.beer
  end

  # Returns a beer style with the highest average rating
  def favorite_style
    return nil if beers.empty?
    beers.select(:style).group(:style).order('avg(ratings.score)').last.style
  end

  # Returns a brewery with the highest average rating
  def favorite_brewery
    return nil if beers.empty?
    beers.select(:brewery_id).group(:brewery_id).order('avg(ratings.score)').last.brewery
  end
end
