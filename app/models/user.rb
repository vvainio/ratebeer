class User < ActiveRecord::Base
  include RatingAverage

  has_many :ratings
end
