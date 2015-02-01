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
end
